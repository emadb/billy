$(function(){
    function ActivitiesVM(acts)
    {
        var self = this;
        this.activities = ko.observableArray(acts);

        this.month = ko.observable();
        this.year = ko.observable();

        this.type = ko.observable();
        this.date = ko.observable()
        this.hours = ko.observable()
        this.description = ko.observable();
        this.jobOrder = ko.observable();
        this.activity = ko.observable();
        this.jobOrders = ko.observableArray();
        this.jobOrderActivities = ko.observableArray();
        this.activityTypes = ko.observableArray();

        this.reload = function(){
            $.getJSON('/user_activities/'+ 1 + '/' + self.year() + '/' + self.month(), function (result){
                self.activities.removeAll();
                $.each(result, function(index, item){
                    self.activities.push(new ActivityVM(item.id, item.type, item.date, item.hours, item.description, item.jobOrder, item.activity));
                });
            });
        };

        this.addActivity = function(){
            var type = self.type();
            var date = self.date();
            var hours = self.hours();
            var description = self.description();
            var jobOrder = self.jobOrder();
            var activity = self.activity();
            var data = { type: type, date:date, hours:hours, description: description, jobOrder: jobOrder, activity: activity };
            $.post('/user_activities', data, function (data){  
                var result = $.parseJSON(data);
                newActivity = new ActivityVM(result.id, result.type, result.date, result.hours, result.description, result.jobOrder, result.activity);
                self.activities.push(newActivity);
               
                self.hours('');
                self.description('');    
                $('#newActivity').addClass('hide');
            });
        };

        this.removeActivity = function(act){
            if (window.confirm('cancellare?')){
                $.ajax({
                        type: 'DELETE',
                        url: 'user_activities/' + act.id(),
                        success: function(){
                             self.activities.remove(act);
                        }
                });
            }
        };

        this.jobOrder.subscribe(function(newJobOrder){
          self.jobOrderActivities.removeAll();
          $.getJSON('/job_orders/' + self.jobOrder(), function(data){
            self.jobOrderActivities(data.activities);
          });
        });
    }

    function ActivityVM(id, type, date, hours, description, jobOrder, activity)
    {
        var self = this;
        this.id = ko.observable(id);
        this.type = ko.observable(type);
        this.date = ko.observable(date);
        this.hours = ko.observable(hours);
        this.description = ko.observable(description);
        this.jobOrder = ko.observable(jobOrder);
        this.activity = ko.observable(activity);
        this.activityJobOrder  = ko.computed(function() {
            return this.activity() + ' (' + this.jobOrder() + ')'
        }, this);
    }   

    function StatsViewModel(today, yesterday){
        this.today_hours = ko.observable(today);
        this.yesterday_hours = ko.observable(yesterday);
    }

    var month = $('#date_month').val();
    var year = $('#date_year').val();
    var user = $('#user').val();

    var activityList = new ActivitiesVM([]);
    
    $.getJSON('/job_orders', function(data){
        activityList.jobOrders(data);
    });

    $.getJSON('/user_activity_types', function(data){
        activityList.activityTypes(data);
    });

    $.getJSON('/user_activities/'+ user + '/' + year + '/' + month, function (result){
        var current = [];
        $.each(result, function(index, item){
            current.push(new ActivityVM(item.id, item.type, item.date, item.hours, item.description, item.jobOrder, item.activity));
        });
        activityList.activities(current);
    });

    ko.applyBindings(activityList, $('.span9')[0]);

    $.getJSON('/user_activities/stats/'+ user + '/' + year + '/' + month, function (response){
        var stats = new StatsViewModel(response.today_hours, response.yesterday_hours);
        ko.applyBindings(stats, $('#stats')[0]);
    });

  
    

    // ko.extenders.logChange = function(target, option) {
    // target.subscribe(function(newValue) {
    //    console.log(option + ": " + newValue);
    // });
    //return target;
    //};
});