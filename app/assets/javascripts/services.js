window.scrooge.factory('ActivityService', ['$http', function($http){
    return {
        getUserActivities: function(month, year, user, successCallback) {
            $http
                .get('/user_activities/'+ user + '/' + year + '/' + month)
                .success(successCallback);
        },
        getUserActivity: function(id, successCallback){
            $http
                .get('/user_activities/' + id)
                .success(successCallback);
        },
        getActivity: function(id, successCallback){
            $http
                .get('/job_order_activities/' + id)
                .success(successCallback);
        },
        getJobOrder: function(id, successCallback){
            $http
                .get('/job_orders/' + id)
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
        },
        delete: function(id, successCallback){
            $http.delete('/user_activities/' + id).success(successCallback);
        },
        getStats: function(year, month, successCallback){
            $http.get('/user_activities/stats/'+ year + '/' + month).success(successCallback);
        }
    }
}]);
