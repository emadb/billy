"use strict";

window.scrooge = angular.module('Scrooge', ['ngResource']);

window.scrooge.config([
  "$httpProvider", function($httpProvider) {
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  }
]);
