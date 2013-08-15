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
        },
        save: function(activity, successCallback){
            $http.post('/user_activities', activity).success(successCallback);
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
        loadActivities();
    }

    $scope.edit = function(id){
         $rootScope.$broadcast('activity:edit', id);
    }   

    $scope.delete = function(id){
    }

    if ($scope.month !== undefined && $scope.year !== undefined && $scope.user !== undefined){
        ActivityService.getActivities($scope.month, $scope.year, $scope.user, function(result){
            $scope.activities = result;
        });
    }

    function loadActivities(){
        ActivityService.getActivities($scope.month, $scope.year, $scope.user, function(result){
            $scope.activities = result;
        });
    }
    setTimeout(function(){loadActivities();}, 0);

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

    $scope.$watch('activity.job_order_id', function(jobOrderId){
        if (jobOrderId !== undefined){
            ActivityService.getJobOrderActivities(jobOrderId, function(result){
                $scope.jobOrderActivities = result;
            });    
        }
    });


    $rootScope.$on('activity:edit', function(event, id) {
        ActivityService.getActivity(id, function(activity){
            $scope.activity = activity;
        })
    });

    $scope.save = function(){    
        ActivityService.save($scope.activity, function(result){
            console.log('updated');
        });
    
    }
}]);


