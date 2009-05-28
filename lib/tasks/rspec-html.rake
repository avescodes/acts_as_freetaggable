namespace :spec do
  desc "Generate HTML spec output in spec/results.html"
  task :html do
    `spec spec -O spec/spec.opts -f h:spec/results.html`
    `open spec/results.html`
  end
end
