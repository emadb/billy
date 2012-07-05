$(function(){
  
    function ActivitiesVM(activities)
    {
        var self = this;
        this.activities = ko.observableArray(activities);

        this.type = ko.observable();
        this.date = ko.observable();
        this.hours = ko.observable();
        this.description = ko.observable();
        this.jobOrder = ko.observable();
        this.activity = ko.observable();

        this.jobOrders = ko.observableArray();
        this.jobOrderActivities = ko.observableArray();

        this.addActivity = function(){
            var type = self.type();
            var date = self.date();
            var hours = self.hours();
            var description = self.description();
            var jobOrder = self.jobOrder();
            var activity = self.activity();

            $.post('user_activities', { type: type, date:date, hours:hours, description: description, jobOrder: jobOrder, activity: activity }, function (result){
                var activity = new ActivityVM(type, date, hours, description, jobOrder, activity);
                
                self.activities.push(activity);
                self.hours('');
                self.description('');    
                $('#newActivity').addClass('hide');
            });
        };

        this.removeActivity = function(act){
            self.activities.remove(act);
            // TODO: remove dal server
            $.ajax('user_activities', {})
        };

        this.jobOrder.subscribe(function(newJobOrder){
          self.activity(undefined);
          self.activities.removeAll();
          $.getJSON('job_orders/' + self.jobOrder(), function(data){
            self.jobOrderActivities(data.activities);
          });
        });
    }

    function ActivityVM(type, date, hours, description, jobOrder, activity)
    {
        var self = this;
        this.id = ko.observable();
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

    var month = $('#date_month').val();
    var year = $('#date_year').val();
    var user = $('#user').val();


    var activityList = new ActivitiesVM([new ActivityVM(1, 'today', '10', 'desc', 'yo', 'acy2')]);
    
    $.getJSON('/job_orders', function(data){
        activityList.jobOrders(data);
    });

    ko.applyBindings(activityList);

    // $.getJSON('/user_activities/'+ user + '/' + year + '/' + month, function (result){
    //     console.log(result);
    //     var activities = [];
    //     $.each(result, function(index, item){
    //         activities.push(new ActivityVM(result.type, result.date, result.hours, result.description));
    //     });
    // })
});