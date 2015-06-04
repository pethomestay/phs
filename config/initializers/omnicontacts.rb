require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, "861312304237-9elrdcdotgg433g648oddc29ej1i0hgu.apps.googleusercontent.com", "O-6uEZ9bXnw4S-KtvWaC-yOy", {:redirect_path => "/invites/gmail/contact_callback"}
end