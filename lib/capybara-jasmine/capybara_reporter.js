(function() {
  var CapybaraReporter = function() {
  }
  CapybaraReporter.prototype = {
    reportRunnerResults: function(runner) {
      this.runner = runner;
      this.output = "";
      this.clean = true;
      for (i in runner.specs()) {
        var spec = runner.specs()[i];
        var results = spec.results();
        var name = spec.description;
        var parent = spec.suite;
        while(parent) {
          name = parent.description + " " + name;
          parent = parent.parentSuite;
        }
        if (results.failedCount > 0) {
          for (j in results.getItems()) {
            var item = results.getItems()[j];
            if (!item.passed()) {
              this.clean = false;
              this.output += "Failed: "+ name + "\n" + item.message + "\n\n";
            }
          }
        } else {
          this.output += "Passed: " + name + "\n";
        }
      }
      this.output = escape(this.output);
      this.done = true;
    },
    done: false
  }

  window.CapybaraReporter = CapybaraReporter;
})()
