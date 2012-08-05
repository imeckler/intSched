var Completable, BinView, CourseView;
I.controls = {};
Completable = (function(superclass){
  var prototype = __extend((__import(Completable, superclass).displayName = 'Completable', Completable), superclass).prototype, constructor = Completable;
  function Completable(){
    return Control.apply(this, arguments);
  }
  prototype.numNeeded = Control.property();
  prototype.watchList = Control.property(function(watchList){
    var e, __i, __ref, __len, __results = [], __this = this;
    this.off();
    for (__i = 0, __len = (__ref = this.watchList()).length; __i < __len; ++__i) {
      e = __ref[__i];
      __results.push(this.on(e, __fn));
    }
    return __results;
    function __fn(ev){
      return __this._numComplete(__this._numComplete() + 1);
    }
  });
  prototype.complete = Control.property.bool(function(complete){
    if (complete) {
      this.trigger(this.title().replace(' ', '_'));
    }
  }, false);
  prototype._numComplete = Control.property(function(numComplete){
    if (numComplete === this.numNeeded()) {
      this.complete(true);
    }
  }, 0);
  prototype.initialize = function(){
    var e, __i, __ref, __len, __results = [], __this = this;
    if (!this.watchList()) {
      return;
    }
    for (__i = 0, __len = (__ref = this.watchList()).length; __i < __len; ++__i) {
      e = __ref[__i];
      __results.push(this.on(e, __fn));
    }
    return __results;
    function __fn(ev){
      return __this._numComplete(__this._numComplete() + 1);
    }
  };
  return Completable;
}(Control));
I.controls.Completable = Completable;
BinView = (function(superclass){
  var prototype = __extend((__import(BinView, superclass).displayName = 'BinView', BinView), superclass).prototype, constructor = BinView;
  function BinView(){
    return Completable.apply(this, arguments);
  }
  prototype.inherited = {
    content: {
      control: CollapsibleWithHeadingButton,
      ref: 'collapsible'
    }
  };
  prototype.complete = function(complete){
    if (complete === void 8) {
      return this._super();
    } else {
      this._super(complete);
      if (complete) {
        return this.css({
          'background-color': 'green'
        });
      } else {
        return this.css({
          'background-color': 'white'
        });
      }
    }
  };
  prototype.number = Control.property();
  prototype.binList = Control.property(function(binList){
    return this.$collapsible().content(binList);
  });
  prototype.obj = Control.property();
  prototype.title = Control.chain('$collapsible', 'heading');
  return BinView;
}(Completable));
I.controls.BinView = BinView;
CourseView = (function(superclass){
  var prototype = __extend((__import(CourseView, superclass).displayName = 'CourseView', CourseView), superclass).prototype, constructor = CourseView;
  function CourseView(){
    return Completable.apply(this, arguments);
  }
  prototype.inherited = {
    draggable: {
      start: function(event, ui){
        return console.log('poopies drag');
      },
      revert: 'invalid',
      helper: 'clone',
      appendTo: 'body'
    }
  };
  prototype.title = Control.chain('content');
  return CourseView;
}(Completable));
I.CourseView = CourseView;
function __extend(sub, sup){
  if (sup.createAt){
      var __hasProp = {}.hasOwnProperty;
      for (var key in sup) {
          if (__hasProp.call(sup, key)) sub[key] = sup[key];
      }
      function ctor() {
          this.constructor = sub;
      }
      ctor.prototype = sup.prototype;
      sub.prototype = new ctor();
      sub.__super__ = sup.prototype;
      return sub;
  }

  function fun(){} fun.prototype = (sub.superclass = sup).prototype;
  (sub.prototype = new fun).constructor = sub;
  if (typeof sup.extended == 'function') sup.extended(sub);
  return sub;
}
function __import(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}