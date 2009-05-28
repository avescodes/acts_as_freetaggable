namespace :spec do
  desc "Generate HTML spec output in spec/results.html"
  task :html do
    `spec spec -O spec/spec.opts -f h:doc/rspec-output.html`
    `open spec/results.html`
  end
end
