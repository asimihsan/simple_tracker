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
      'user_login_title': 'Login',
      'user_login_username': 'Username',
      'user_login_password': 'Password',
      'user_login_error_username_empty': 'Please enter some text for the username.',
      'user_login_error_username_too_short': 'Username must be at least 4 characters long.',
      'user_login_error_username_too_long': 'Username must be at most 40 characters long.',
      'user_login_error_username_invalid_chars': 'Username characters must match A-Z a-z 0-9 _ - .',
      'user_login_processing_data': 'Processing data...',
      'user_login_error_password_empty': 'Please enter some text for the password.',
      'user_login_error_password_too_long': 'Password must be at most 128 characters long.',
    },
  };

  String get userLoginTitle {
    return _localizedValues[locale.languageCode]['user_login_title'];
  }

  String get userLoginUsername {
    return _localizedValues[locale.languageCode]['user_login_username'];
  }

  String get userLoginPassword {
    return _localizedValues[locale.languageCode]['user_login_password'];
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
