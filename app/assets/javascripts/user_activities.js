window.scrooge.factory('ActivityService', ['$http', function($http){
    return {
        getActivities: function(month, year, user, successCallback) {
            $http
                .get('/user_activities/'+ user + '/' + year + '/' + month)
                .success(successCallback);
        },
        getActivity: function(id, successCallback){
            $http
                .get('/user_activities/' + id)
                .success(successCallback);
        },
        getJobOrders: function(successCallback){
            $http.get('/job_orders').success(successCallback);
        },
        getJobOrderActivities: function(jobOrderId, successCallback){
          $http.get('/job_orders/' + jobOrderId + '/job_order_activities').success(successCallback);  
        }

    }
}]);

window.scrooge.controller('UserActivitiesCtrl', ['$scope', '$rootScope', 'ActivityService', function($scope, $rootScope, ActivityService){
    $scope.days = ['lunedì', 'martedì', 'mercoledì', 'giovedì', 'venerdì', 'sabato', 'domenica'];
    $scope.month = moment().month() + 1;
    $scope.year = moment().year(); 
    
    $scope.getDay = function(date){
        return $scope.days[moment(date).day()];
    }
    
    $scope.filter = function(){
        console.log('click');
        ActivityService.getActivities($scope.month, $scope.year, $scope.user, function(result){
            $scope.activities = result;
            console.log('filter', result);
        });
    }

    $scope.edit = function(id){
         $rootScope.$broadcast('activity:edit', id);
    }   

    $scope.delete = function(id){
        console.log('delete', id);
    }

    if ($scope.month !== undefined && $scope.year !== undefined && $scope.user !== undefined){
        ActivityService.getActivities($scope.month, $scope.year, $scope.user, function(result){
            $scope.activities = result;
            console.log('1', result);
        });
    }

       //  ko.applyBindings(activityList, $('#activityPage')[0]);

       //  // fill the modal popup
       //  var activity = new NewActivityVM();
       //  activity.init();
       //  ko.applyBindings(activity, $('#newActivity')[0]);

       // updateStats();
}]);

window.scrooge.controller('UserActivityCtrl', ['$scope', '$rootScope', 'ActivityService', function($scope, $rootScope, ActivityService){
        
    ActivityService.getJobOrders(function(result){
        $scope.jobOrders = result;
    })

    ActivityService.getJobOrderActivities(2, function(result){
        $scope.jobOrderActivities = result;
    })


    $rootScope.$on('activity:edit', function(event, id) {
        ActivityService.getActivity(id, function(activity){
            $scope.activity = activity;
        })
    });
}]);


