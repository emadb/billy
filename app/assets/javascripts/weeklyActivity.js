window.scrooge.controller('WeeklyActivity', ['$scope', '$http', 'ActivityService', function($scope, $http, ActivityService){
  
  var emptyRow = {job_order_id:null, activity_id:null, hours:[0, 0, 0, 0, 0, 0, 0]};

  $scope.rows =[angular.copy(emptyRow)];
  $scope.totals = [0,0,0,0,0,0,0];

  $scope.addRow = function(){
    $scope.rows.push(angular.copy(emptyRow));
  };

  $scope.loadActivities = function(index, jid){
    $http.get('/job_orders/' + jid + '/job_order_activities').success(function(acts){
      $scope.rows[index].activities = acts;
    });  
  };

  $scope.save = function(){
    console.log($scope.rows);
    $http.post('/weekly_activities', $scope.rows).success(function(){

    });
  };

  $scope.updateTotals = function(){
    for(var d=0;d<7;d++){
      $scope.totals[d] = _.reduce($scope.rows, function(memo, r){ return parseInt(memo) + parseInt(r.hours[d]); }, 0);
    }
  };

  $http.get('/job_orders').success(function(jo){
    $scope.jobOrders = jo;
  });





  // var getActivity = function(id, successCallback){
  //   $http
  //     .get('/job_order_activities/' + id)
  //     .success(successCallback);
  // };

  // var getJobOrder: function(id, successCallback){
  //   $http
  //     .get('/job_orders/' + id)
  //     .success(successCallback);
  // };

  // var getJobOrders: function(successCallback){
  //   $http.get('/job_orders').success(successCallback);
  // };

  // var getJobOrderActivities: function(jobOrderId, successCallback){
  //   $http.get('/job_orders/' + jobOrderId + '/job_order_activities').success(successCallback);  
  // };


}]);