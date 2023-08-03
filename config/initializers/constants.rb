VALID_EMAIL_REGEX = /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i.freeze
DEFAULT_EMAIL = "me@mydomain.com".freeze
COOKIE_EXPIRATION_TIME = 1.day.from_now
REPORTS_THRESHOLD = 1
ADMIN_USER = User.find(1)
VERFICATION_CREDIT_AMOUNT = 5
MINIMUM_VOTES_TO_REWARD_CREDITS = 2
