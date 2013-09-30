window.scrooge.controller('TrackerCtrl', ['$scope', '$rootScope', '$timeout', 'ActivityService', function($scope, $rootScope, $timeout, ActivityService){
    var isStarted = false;
    var watch = new Stopwatch();
    var clocktimer;
    $scope.activities = [];
    $scope.operation = 'Start';
    $scope.cssClass = 'btn-success';

    ActivityService.getActivityTrackedToday(function(activities){
        activities.forEach(function(activity){
            $scope.activities.push(activity);    
        });
    })


    $rootScope.$on('tracker:deleteAll', function(event) {
        $scope.activities.length = 0;
    });

    $rootScope.$on('tracker:saveAll', function(event) {
        $scope.activities.forEach(function(activity){
            var newTrackeActivity = {
                time: activity.time, 
                job_order_id: activity.job_order_id,
                job_order_activity_id: activity.job_order_activity_id,
                date: moment().format('YYYY-MM-DD'),
                hours: buildDuration(activity.time),
                description: activity.notes
            };
            ActivityService.save(newTrackeActivity, function(response){
                ActivityService.markSaved(activity);
            });
        });
        $scope.activities.length = 0;
    });


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

    $scope.start = function(activity){
        if (!isStarted){
            $scope.startTime = moment().format('HH:mm');
            startTimer(activity);
        } else{
            $scope.stopTime = moment().format('HH:mm')
            stopTimerAndTrack();
        }
        isStarted = !isStarted;
    };

    $scope.delete = function(activity){
        ActivityService.deleteTrackedActivity(activity.id, function(){
            index = $scope.activities.map(function(a) { return a.id; }).indexOf(activity);    
            $scope.activities.splice(index, 1);
        });    
    }

    $scope.isStarted = function(){
        return isStarted;
    }

    $scope.isCompleted = function(){
        return !isStarted && $scope.timer !== undefined && $scope.timer !== '';
    }


    function buildDuration(time){
        var hours = 0;
        var duration = moment.duration(time)
        hours = duration.hours()
        if (duration.minutes() > 15 && duration.minutes() < 45){
            hours = hours + 0.5
        }
        if (duration.minutes() > 45){
            hours = hours + 1
        }
        return hours;
    }

    function update() {
        $scope.timer = watch.getTime();
        clocktimer = $timeout(update, 30);
    }

    function trackActivity(){
        ActivityService.getJobOrder($scope.job_order_id, function(job_order){
            ActivityService.getActivity($scope.job_order_activity_id, function(activity){
                var activityToTrack = {
                    jobOrder: job_order.code, 
                    activity: activity.description,
                    time: watch.getTime(),
                    job_order_id: $scope.job_order_id,
                    job_order_activity_id: $scope.job_order_activity_id,
                    notes: $scope.notes,
                    start_time: $scope.startTime,
                    stop_time: $scope.stopTime
                };
                $scope.activities.push(activityToTrack);
                ActivityService.trackActivity(activityToTrack, function(response){
                    activityToTrack.id = response.activityId;    
                });
            });    
        });

        
    }

    function startTimer(activity){
        if (activity !== undefined){
            $scope.job_order_id = activity.job_order_id;
            $scope.job_order_activity_id = activity.job_order_activity_id;
            $scope.notes = activity.notes;
        }
        watch.reset();
        $scope.operation = 'Stop';
        $scope.cssClass = 'btn-danger';
        clocktimer = $timeout(update, 30);
        watch.start();
    }

    function stopTimerAndTrack(){
        $scope.operation = 'Start';
        $scope.cssClass = 'btn-success';
        $timeout.cancel(clocktimer);
        watch.stop();
        trackActivity();
    }

    
    function Stopwatch() {
        var startAt = 0;    // Time of last start / resume. (0 if not running)
        var lapTime = 0;    // Time on the clock when last stopped in milliseconds
        var resumeTime = 0;
 
        var now = function() {
            return (new Date()).getTime(); 
        }; 
        var pad = function (num, size) {
            var s = "0000" + num;
            return s.substr(s.length - size);
        };

        this.getTime = function() {
            var t = this.time() + resumeTime;
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

        this.resume = function(time){
            var parts = time.split(':');
            var s = parseInt(parts[2]);
            var m = parseInt(parts[1]);
            var h = parseInt(parts[0]);
            resumeTime = (s + (m * 60) + (h * 60 * 60)) * 1000;
            this.start();
        };
    };
}]);

window.scrooge.controller('TrackerSideBarCtrl', ['$scope', '$rootScope',function($scope, $rootScope){
    
    $scope.deleteAll = function(){
        if (window.confirm('Sicuro?')){
            $rootScope.$broadcast('tracker:deleteAll');
        }
    }

    $scope.saveAll = function(){
        $rootScope.$broadcast('tracker:saveAll');
    }   
}])

