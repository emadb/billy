$(function(){
    var postbox = new ko.subscribable();
    var days = ['lunedì', 'martedì', 'mercoledì', 'giovedì', 'venerdì', 'sabato', 'domenica'];
    var updateStats = function(){
        $.getJSON('/user_activities/stats/'+ user + '/' + year + '/' + month, function (response){
            var stats = new StatsViewModel(response.today_hours, response.yesterday_hours);
            ko.applyBindings(stats, $('#stats')[0]);
        });
    };


    ko.bindingHandlers.dateString = {
        update: function(element, valueAccessor, allBindingsAccessor, viewModel) {
            var value = valueAccessor(),
                allBindings = allBindingsAccessor();
            var valueUnwrapped = ko.utils.unwrapObservable(value);
            window.date = moment(valueUnwrapped);
            $(element).text(date.format('DD-MM-YYYY'));
            
        }
    }

    function ActivtyPage(activities){
        var self = this;

        self.month = ko.observable();
        self.year = ko.observable();
        self.user = ko.observable();

        self.activities = ko.observableArray(activities);

        postbox.subscribe(function(data){
            self.activities.push(data);
        }, self, 'new-activity-created');

         postbox.subscribe(function(data){
            for(var i=0; i<self.activities().length;i++){
                if (self.activities()[i].id() == data.id()){
                    var activity = self.activities()[i];
                    activity.date(data.date());
                    activity.hours(data.hours())
                    activity.description(data.description());
                    activity.jobOrder(data.jobOrder());
                    activity.activity(data.activity());
                }
            }
        }, self, 'activity-updated');

        this.reload = function(){
            $.getJSON('/user_activities/'+ self.user() + '/' + self.year() + '/' + self.month(), function (result){
                self.activities.removeAll();
                if (result.length > 0){
                    var currentDay = moment(result[0].date).date();
                    $.each(result, function(index, item){
                        var background = '';
                        var day = moment(item.date).date()
                         if (currentDay !== day){
                            currentDay = day;
                            background = background === '' ? 'line':'';
                        }
                        self.activities.push(new ActivityVM(item.id, item.date, item.hours, item.description, item.jobOrder, item.activity, background));
                    });
                }
            });

            updateStats();
           
        };

    }

    function NewActivityVM(){
        var self = this;
        self.id = ko.observable();
        self.jobOrders = ko.observableArray();
        self.jobOrderActivities = ko.observableArray();

        self.date = ko.observable(moment().format('DD-MM-YYYY'));
        self.hours = ko.observable();
        self.description = ko.observable();
        self.jobOrder = ko.observable();
        self.activity = ko.observable();

        self.jobOrder.subscribe(function(newValue) {
             self.loadJobOrderActivities(newValue);
        });

        self.save = function(){
            var dateTemp = $('#date').val();
            var data = { id: self.id(), date:dateTemp, hours:self.hours(), description: self.description(), jobOrder: self.jobOrder(), activity: self.activity() };
            $.post('/user_activities', data, function (data){  
                var result = $.parseJSON(data);
                var newActivity = new ActivityVM(result.id, result.date, result.hours, result.description, result.jobOrder, result.activity);
                if(self.id() === undefined){
                    postbox.notifySubscribers(newActivity, 'new-activity-created');
                }else{
                    postbox.notifySubscribers(newActivity, 'activity-updated');
                }
                self.hours('');
                self.description('');    
                $('#newActivity').modal('hide');
                updateStats();
            });
        }

        self.loadJobOrderActivities = function(jobOrderId){
            $.getJSON('/job_orders/' + jobOrderId + '/job_order_activities', function(data){
                self.jobOrderActivities(data);
                self.activity(self.jobOrderActivities()[0]);
            });
        }

        self.init = function(){
            $.getJSON('/job_orders', function(data){
                self.jobOrders(data);
                self.loadJobOrderActivities(self.jobOrder());
            });
        }
        postbox.subscribe(function(id){
            $.get('user_activities/' + id, function(activity){
                self.id(id);
                self.jobOrder(activity.job_order_id);
                self.date(moment(activity.date).format('DD-MM-YYYY'));
                self.hours(activity.hours);
                self.description(activity.description);
                self.activity(activity.job_order_activity_id);
                $('#newActivity').modal('show');    
            })

            
        }, self, 'edit-activity');

    }
    
    function ActivityVM(id, date, hours, description, jobOrder, activity, background)
    {
        var self = this;

        this.id = ko.observable(id);
        this.date = ko.observable(date);
        this.day = ko.computed(function(){
            return days[moment(date).day() - 1];
        });
        this.hours = ko.observable(hours);
        this.description = ko.observable(description);
        this.jobOrder = ko.observable(jobOrder);
        this.activity = ko.observable(activity);

        this.isVisible = ko.observable(true);
        this.background = ko.observable(background);

        self.removeActivity = function(){
            if (window.confirm('cancellare?')){
                $.ajax({
                        type: 'DELETE',
                        url: 'user_activities/' + self.id(),
                        success: function(){
                             self.isVisible(false);
                             updateStats();
                        }
                });
            }
        };
        self.editActivity = function(){
            postbox.notifySubscribers(self.id(), 'edit-activity');
        }
    }   

    function StatsViewModel(today, yesterday){
        var self = this;
        this.today_hours = ko.observable(today);
        this.yesterday_hours = ko.observable(yesterday);
        this.today_hours_txt = ko.computed(function(){
            return self.today_hours() + ' h';
        })

        this.yesterday_hours_txt = ko.computed(function(){
            return self.yesterday_hours() + ' h';
        })
    }

    var month = $('#date_month').val();
    var year = $('#date_year').val();
    var user = $('#user').val();

    $('#openModal').click(function(){
        $('#newActivity').find('#id').val('');
        $('#newActivity').modal();
    });


    if (month !== undefined && year !== undefined && user !== undefined){

        var activityList = new ActivtyPage([]);
        
        $.getJSON('/user_activities/'+ user + '/' + year + '/' + month, function (result){
            var current = [];
            var currentDay = moment(result[0].date).date();
            
            $.each(result, function(index, item){
                var background = '';
                var day = moment(item.date).date();
                if (currentDay !== day){
                    currentDay = day;
                    background = background === '' ? 'line':'';
                }
                current.push(new ActivityVM(item.id, item.date, item.hours, item.description, item.jobOrder, item.activity, background));
            });
            activityList.activities(current);
        });

        ko.applyBindings(activityList, $('#activityPage')[0]);

        // fill the modal popup
        var activity = new NewActivityVM();
        activity.init();
        ko.applyBindings(activity, $('#newActivity')[0]);

       updateStats();
    }

    $('#report').click(function(){
        
        var month = $('#date_month').val();
        var year = $('#date_year').val();
        var user = $('#user').val();

        if (month !== undefined && year !== undefined && user !== undefined){
            var url = $(this).attr('href') +'?user=' + user + '&year=' + year + '&month=' + month;
            $('#frm').src = url;
            window.location = url;
        }
        return false;


    });
});
