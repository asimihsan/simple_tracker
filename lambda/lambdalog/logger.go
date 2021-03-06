/*
 * ============================================================================
 *  Copyright 2020 Asim Ihsan. All rights reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License in the LICENSE file and at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 * ============================================================================
 */

package lambdalog

import (
	"fmt"
)

var LambdaLog Logger

type Logger interface {
	Printf(format string, v ...interface{})
	Println(v ...interface{})
}

type loggerImpl struct {
	lambdaRequestId string
}

func SetGlobalLogger(lambdaRequestId string) {
	LambdaLog = &loggerImpl{
		lambdaRequestId: fmt.Sprintf("%s", lambdaRequestId)}
}

func (l *loggerImpl) Printf(format string, v ...interface{}) {
	fmt.Printf("[%v] ", l.lambdaRequestId)
	fmt.Printf(format, v...)
}

func (l *loggerImpl) Println(v ...interface{}) {
	fmt.Printf("[%v] ", l.lambdaRequestId)
	fmt.Println(v...)
}