window.scrooge.controller('TrackerCtrl', ['$scope', '$rootScope', '$timeout', 'ActivityService', function($scope, $rootScope, $timeout, ActivityService){
    var isStarted = false;
    var watch = new Stopwatch();
    var clocktimer;
    $scope.activities = [];
    $scope.operation = 'Start';
    $scope.cssClass = 'btn-success';


    ActivityService.getJobOrders(function(result){
        $scope.jobOrders = result;
    });

    $scope.$watch('job_order_id', function(jobOrderId){
        if (jobOrderId !== undefined){
            ActivityService.getJobOrderActivities(jobOrderId, function(result){
                $scope.jobOrderActivities = result;
            });    
        }
    });

    function update() {
        $scope.timer = watch.getTime();
        clocktimer = $timeout(update, 10);
    }

    function trackActivity(){
        ActivityService.getJobOrder($scope.job_order_id, function(job_order){
            ActivityService.getActivity($scope.job_order_activity_id, function(activity){
                $scope.activities.push({
                    jobOrder: job_order.code, 
                    activity: activity.description,
                    time: watch.getTime()
                });
            });    
        })
        
    }

    $scope.start = function(){
        if (!isStarted){
            $scope.operation = 'Stop';
            $scope.cssClass = 'btn-danger';
            clocktimer = $timeout(update, 10);
            watch.start();
        } else{
            $scope.operation = 'Start';
            $scope.cssClass = 'btn-success';
            $timeout.cancel(clocktimer);
            watch.stop();
            trackActivity();
        }

        isStarted = !isStarted;

    };

    
    function Stopwatch() {
        var startAt = 0;    // Time of last start / resume. (0 if not running)
        var lapTime = 0;    // Time on the clock when last stopped in milliseconds
 
        var now = function() {
            return (new Date()).getTime(); 
        }; 
        var pad = function (num, size) {
            var s = "0000" + num;
            return s.substr(s.length - size);
        };

        this.getTime = function() {
            var t = this.time();
            var h = m = s = 0;
            var newTime = '';
         
            h = Math.floor( t / (60 * 60 * 1000) );
            t = t % (60 * 60 * 1000);
            m = Math.floor( t / (60 * 1000) );
            t = t % (60 * 1000);
            s = Math.floor( t / 1000 );
         
            newTime = pad(h, 2) + ':' + pad(m, 2) + ':' + pad(s, 2);
            return newTime;
        };
 
        // Public methods
        // Start or resume
        this.start = function() {
            startAt = startAt ? startAt : now();
        };
 
        // Stop or pause
        this.stop = function() {
            // If running, update elapsed time otherwise keep it
            lapTime = startAt ? lapTime + now() - startAt : lapTime;
            startAt = 0; // Paused
        };
 
        // Reset
        this.reset = function() {
            lapTime = startAt = 0;
        };

        // Duration
        this.time = function() {
            return lapTime + (startAt ? now() - startAt : 0); 
        };
    };


}]);

