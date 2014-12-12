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

  $http.get('/weekly_activities/current_week').success(function(acts){
    Object.keys(acts).forEach(function(a){
      var newOne = {job_order_id: acts[a].jid, activity_id:parseInt(a), hours:acts[a].hours};
      $scope.rows.push(newOne);  
    });
    $scope.rows.forEach(function(r, i){
      if (r.job_order_id){
        $scope.loadActivities(i, r.job_order_id);
      }
    });
  });
}]);