// ============================================================================
//  Copyright 2020 Asim Ihsan. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License in the LICENSE file and at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'user_login_login_title': 'Login',
      'user_login_signup_title': 'Signup',
      'user_login_username': 'Username',
      'user_login_password': 'Password',
      'user_login_confirm_password': 'Confirm New Password',
      'user_login_error_username_empty': 'Please enter some text for the username.',
      'user_login_error_username_too_short': 'Username must be at least 4 characters long.',
      'user_login_error_username_too_long': 'Username must be at most 40 characters long.',
      'user_login_error_username_invalid_chars': 'Username characters must match A-Z a-z 0-9 _ - .',
      'user_login_processing_data': 'Processing data...',
      'user_login_error_password_empty': 'Please enter some text for the password.',
      'user_login_error_password_too_long': 'Password must be at most 128 characters long.',
      'user_login_sign_up_as_a_new_user': 'Sign up as a new user',
      'user_login_login_as_existing_user': 'Log in as a existing user',
      'user_login_submit_button': 'Submit',
      'user_login_confirm_password_does_not_match':
          'Confirmation password does not match original password',
    },
  };

  String get userLoginLoginTitle {
    return _localizedValues[locale.languageCode]['user_login_login_title'];
  }

  String get userLoginSignupTitle {
    return _localizedValues[locale.languageCode]['user_login_signup_title'];
  }

  String get userLoginUsername {
    return _localizedValues[locale.languageCode]['user_login_username'];
  }

  String get userLoginPassword {
    return _localizedValues[locale.languageCode]['user_login_password'];
  }

  String get userLoginConfirmPassword {
    return _localizedValues[locale.languageCode]['user_login_confirm_password'];
  }

  String get userLoginErrorUsernameEmpty {
    return _localizedValues[locale.languageCode]['user_login_error_username_empty'];
  }

  String get userLoginErrorUsernameTooShort {
    return _localizedValues[locale.languageCode]['user_login_error_username_too_short'];
  }

  String get userLoginErrorUsernameTooLong {
    return _localizedValues[locale.languageCode]['user_login_error_username_too_long'];
  }

  String get userLoginErrorUsernameInvalidChars {
    return _localizedValues[locale.languageCode]['user_login_error_username_invalid_chars'];
  }

  String get userLoginProcessingData {
    return _localizedValues[locale.languageCode]['user_login_processing_data'];
  }

  String get userLoginErrorPasswordEmpty {
    return _localizedValues[locale.languageCode]['user_login_error_password_empty'];
  }

  String get userLoginErrorPasswordTooLong {
    return _localizedValues[locale.languageCode]['user_login_error_password_too_long'];
  }

  String get userLoginSignUpAsANewUser {
    return _localizedValues[locale.languageCode]['user_login_sign_up_as_a_new_user'];
  }

  String get userLoginLoginAsExistingUser {
    return _localizedValues[locale.languageCode]['user_login_login_as_existing_user'];
  }

  String get userLoginSubmitButton {
    return _localizedValues[locale.languageCode]['user_login_submit_button'];
  }

  String get userLoginConfirmPasswordDoesNotMatch {
    return _localizedValues[locale.languageCode]['user_login_confirm_password_does_not_match'];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return {'en'}.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async load operation isn't needed
    // to provude an instance of AppLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
