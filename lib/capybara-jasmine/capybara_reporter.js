(function() {
  var CapybaraReporter = function() {
  }
  CapybaraReporter.prototype = {
    reportRunnerResults: function(runner) {
      this.runner = runner;
      this.output = [];
      this.errors = [];
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
              this.errors.push("Failed: "+ name + "\n" + item.message);
              this.output.push("F");
            }
          }
        } else {
          this.output.push(".");
        }
      }
      this.output = this.output.join("")
      if (this.errors.length > 0) {
        this.output += "\n\n" + this.errors.join("\n\n") + "\n";
      }
      this.output = escape(this.output + "\n");
      this.done = true;
    },
    done: false
  }

  window.CapybaraReporter = CapybaraReporter;
})()
