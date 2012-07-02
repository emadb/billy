$(function(){
  
    function ActivitiesVM(activities)
    {
        var self = this;
        this.activities = ko.observableArray(activities);

        this.type = ko.observable();
        this.date = ko.observable();
        this.hours = ko.observable();
        this.description = ko.observable();

        this.addActivity = function(){
            var activity = new ActivityVM(self.type(), self.date(), self.hours(), self.description());
            console.log(self.date());
            self.activities.push(activity);
            self.hours('');
            self.description('');
        };
    }

    function ActivityVM(type, date, hours, description)
    {
        var self = this;
        this.type = ko.observable(type);
        this.date = ko.observable(date);
        this.hours = ko.observable(hours);
        this.description = ko.observable(description);
    }

    var month = $('#date_month').val();
    var year = $('#date_year').val();
    var user = $('#user').val();


    vm = new ActivitiesVM([new ActivityVM(1, 'today', '10', 'desc')]);
    ko.applyBindings(vm);

    // $.getJSON('/user_activities/'+ user + '/' + year + '/' + month, function (result){
    //     console.log(result);
    //     var activities = [];
    //     $.each(result, function(index, item){
    //         activities.push(new ActivityVM(result.type, result.date, result.hours, result.description));
    //     });
    // })
});