# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "typed.js" # @2.1.0
pin "@stimulus-components/auto-submit", to: "@stimulus-components--auto-submit.js" # @6.0.0
pin "@kanety/stimulus-dropzone", to: "@kanety--stimulus-dropzone.js" # @1.1.0
pin "@kanety/stimulus-static-actions", to: "@kanety--stimulus-static-actions.js" # @1.1.0
