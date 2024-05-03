# We use verbs to distinguish between different types of events.
# The following is a a list of verbs which hold special semantic meaning to us.
# In addition to these you can send any verb you like.
#
# Learn more about these verbs, and others, here:
#   http://help.thisdata.com/docs/verbs
#
module ThisData
  class Verbs

    LOG_IN                = 'log-in'
    LOG_OUT               = 'log-out'
    LOG_IN_DENIED         = 'log-in-denied'
    LOG_IN_CHALLENGE      = 'log-in-challenge'
    LOG_INTO_APP          = 'log-into-app'
    DESKTOP_LOGIN_SUCCESS = 'desktop-login-success'

    ACCESS                = 'access'

    EMAIL_UPDATE          = 'email-update'
    PASSWORD_UPDATE       = 'password-update'

    PASSWORD_RESET_REQUEST  = 'password-reset-request'
    PASSWORD_RESET          = 'password-reset'
    PASSWORD_RESET_FAIL     = 'password-reset-fail'

    AUTHENTICATION_CHALLENGE      = 'authentication-challenge'
    AUTHENTICATION_CHALLENGE_PASS = 'authentication-challenge-pass'
    AUTHENTICATION_CHALLENGE_FAIL = 'authentication-challenge-fail'

    TWO_FACTOR_DISABLE = 'two-factor-disable'

  end
end