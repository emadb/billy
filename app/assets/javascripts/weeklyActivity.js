window.scrooge.controller('WeeklyActivity', ['$scope', '$http', '$location', 'ActivityService', function($scope, $http, $location, ActivityService){
  
  var emptyRow = {job_order_id:null, activity_id:null, hours:[0, 0, 0, 0, 0, 0, 0]};

  $scope.rows =[angular.copy(emptyRow)];
  $scope.totals = [0,0,0,0,0,0,0];
  $scope.week_total = 0;

  $scope.addRow = function(){
    $scope.rows.push(angular.copy(emptyRow));
  };

  $scope.deleteRow = function(row){
    $scope.rows = _.reject($scope.rows, function(item) {
        return item == row; 
    });
  };

  $scope.loadActivities = function(index, jid){
    $http.get('/job_orders/' + jid + '/job_order_activities').success(function(acts){
      $scope.rows[index].activities = acts;
    });  
  };

  $scope.save = function(){
    var startday = getStartDay();
    $http.post('/weekly_activities?startday=' + startday, $scope.rows).success(function(){
      alert('week saved!');
    });
  };

  $scope.updateTotals = function(){
    for(var d=0;d<7;d++){
      $scope.totals[d] = _.reduce($scope.rows, function(memo, r){ return parseInt(memo) + parseInt(r.hours[d]); }, 0);
    }
    $scope.week_total = _.reduce($scope.totals, function(memo, num){ return memo + num; }, 0);

  };

  $http.get('/job_orders').success(function(jo){
    $scope.jobOrders = jo;
  });

  var startday = getStartDay();
  $http.get('/weekly_activities/current_week?startday=' + startday).success(function(acts){
    createRows(acts);
    $scope.updateTotals();
  });

  function getStartDay(){
    var startday = '';
    if (window.location.search.indexOf('startday') > 0){
      startday = window.location.search.split('=')[1];
    }
    return startday;
  }

  function createRows(acts){
    Object.keys(acts).forEach(function(a){
      var newOne = {job_order_id: acts[a].jid, activity_id:parseInt(a), hours:acts[a].hours};
      $scope.rows.push(newOne);  
    });
    $scope.rows.forEach(function(r, i){
      if (r.job_order_id){
        $scope.loadActivities(i, r.job_order_id);
      }
    });
  }
}]);