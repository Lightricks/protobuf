# Copyright (c) 2009-2021, Google LLC
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Google LLC nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL Google LLC BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

from google.protobuf.internal import unknown_fields_test
import unittest

# We must skip these tests entirely (rather than running them with
# __unittest_expecting_failure__) because they error out in setUp():
#
#  NotImplementedError: access repeated
#
# TODO: change to __unittest_expecting_failure__ when repeated fields are available
unknown_fields_test.UnknownEnumValuesTest.testCheckUnknownFieldValueForEnum.__unittest_skip__ = True
unknown_fields_test.UnknownEnumValuesTest.testRoundTrip.__unittest_skip__ = True
unknown_fields_test.UnknownEnumValuesTest.testUnknownEnumValue.__unittest_skip__ = True
unknown_fields_test.UnknownEnumValuesTest.testUnknownPackedEnumValue.__unittest_skip__ = True
unknown_fields_test.UnknownEnumValuesTest.testUnknownParseMismatchEnumValue.__unittest_skip__ = True
unknown_fields_test.UnknownEnumValuesTest.testUnknownRepeatedEnumValue.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsAccessorsTest.testCheckUnknownFieldValue.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsAccessorsTest.testClear.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsAccessorsTest.testCopyFrom.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsAccessorsTest.testMergeFrom.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsAccessorsTest.testSubUnknownFields.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsAccessorsTest.testUnknownExtensions.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsAccessorsTest.testUnknownField.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsAccessorsTest.testUnknownFieldsNoMemoryLeak.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsTest.testByteSize.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsTest.testDiscardUnknownFields.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsTest.testEquals.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsTest.testListFields.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsTest.testSerialize.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsTest.testSerializeMessageSetWireFormatUnknownExtension.__unittest_skip__ = True
unknown_fields_test.UnknownFieldsTest.testSerializeProto3.__unittest_skip__ = True

if __name__ == '__main__':
  unittest.main(module=unknown_fields_test, verbosity=2)
