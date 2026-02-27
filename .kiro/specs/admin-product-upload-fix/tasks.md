# Implementation Plan

- [-] 1. Write bug condition exploration test
  - **Property 1: Fault Condition** - Invalid JSON Response for Product Upload with Image
  - **CRITICAL**: This test MUST FAIL on unfixed code - failure confirms the bug exists
  - **DO NOT attempt to fix the test or the code when it fails**
  - **NOTE**: This test encodes the expected behavior - it will validate the fix when it passes after implementation
  - **GOAL**: Surface counterexamples that demonstrate the bug exists
  - **Scoped PBT Approach**: Scope the property to concrete failing cases - product uploads with image files that return invalid JSON
  - Test that product upload with image file returns valid, parseable JSON (from Fault Condition in design)
  - Test implementation: Send POST request to /api/products with multipart form data including image file, capture raw response, attempt to parse as JSON
  - The test assertions should verify: response body is valid JSON, can be parsed without FormatException, contains product_id field
  - Run test on UNFIXED code
  - **EXPECTED OUTCOME**: Test FAILS (this is correct - it proves the bug exists)
  - Document counterexamples found: PHP warnings/notices prepended to JSON, HTML error pages, trailing whitespace/closing tags, encoding issues
  - Mark task complete when test is written, run, and failure is documented
  - _Requirements: 2.1, 2.4_

- [~] 2. Write preservation property tests (BEFORE implementing fix)
  - **Property 2: Preservation** - Non-Multipart Operations Unchanged
  - **IMPORTANT**: Follow observation-first methodology
  - Observe behavior on UNFIXED code for non-buggy inputs (non-multipart operations)
  - Test cases to observe: GET /products (retrieval), PUT /products?id=X (update), DELETE /products?id=X (delete), POST /products with image_url only (no file)
  - Write property-based tests capturing observed behavior patterns from Preservation Requirements
  - Property-based testing generates many test cases for stronger guarantees
  - Test implementation: For all non-multipart API operations, verify responses are valid JSON and match expected structure
  - Run tests on UNFIXED code
  - **EXPECTED OUTCOME**: Tests PASS (this confirms baseline behavior to preserve)
  - Mark task complete when tests are written, run, and passing on unfixed code
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

- [ ] 3. Fix for invalid JSON response in product upload with image

  - [~] 3.1 Implement backend output buffer cleaning in products.php
    - Add `ob_start()` at the beginning of the file after opening PHP tag
    - Add `ob_clean()` before echoing final JSON response to discard accidental output
    - Add `ob_end_flush()` after echoing response
    - Ensure `header('Content-Type: application/json')` is set early
    - _Bug_Condition: isBugCondition(input) where input.hasImageFile == true AND backendResponse.isValidJSON() == false_
    - _Expected_Behavior: Backend SHALL return valid, parseable JSON for all product creation requests with images_
    - _Preservation: Non-multipart operations (GET, PUT, DELETE, POST without files) must remain unchanged_
    - _Requirements: 2.1, 2.4_

  - [~] 3.2 Update jsonResponse and errorResponse helpers in bootstrap.php
    - Modify `jsonResponse()` to clean output buffer before sending JSON: `if (ob_get_level() > 0) ob_clean();`
    - Modify `errorResponse()` to clean output buffer before sending JSON
    - Move `header('Content-Type: application/json')` to the very top of bootstrap.php
    - Ensure consistent use of `JSON_UNESCAPED_UNICODE` flag
    - _Bug_Condition: isBugCondition(input) where input.hasImageFile == true AND backendResponse.isValidJSON() == false_
    - _Expected_Behavior: All JSON responses SHALL be valid and parseable_
    - _Preservation: All existing API endpoints must continue to return valid JSON_
    - _Requirements: 2.1, 2.4_

  - [~] 3.3 Verify and remove PHP closing tags
    - Check products.php, bootstrap.php, productController.php, product.php for closing `?>` tags
    - Remove any closing tags that could introduce trailing whitespace
    - Verify no whitespace after final code in each file
    - _Bug_Condition: isBugCondition(input) where input.hasImageFile == true AND backendResponse.isValidJSON() == false_
    - _Expected_Behavior: No trailing content should corrupt JSON responses_
    - _Preservation: File structure and functionality must remain unchanged_
    - _Requirements: 2.1, 2.4_

  - [~] 3.4 Add response validation in products.php
    - Before sending response, validate JSON encoding succeeded
    - Check `json_last_error() !== JSON_ERROR_NONE`
    - Add error logging for JSON encoding failures
    - Return proper 500 error response if JSON encoding fails
    - _Bug_Condition: isBugCondition(input) where input.hasImageFile == true AND backendResponse.isValidJSON() == false_
    - _Expected_Behavior: Backend SHALL detect and handle JSON encoding errors gracefully_
    - _Preservation: Error handling for other operations must remain unchanged_
    - _Requirements: 2.1, 2.4_

  - [~] 3.5 Improve frontend response validation in api_service.dart
    - Add response body trimming and empty check before JSON decode
    - Add validation that response starts with '{' or '[' before parsing
    - Improve error messages to include actual response content for debugging
    - Add `_tryJsonDecode()` helper with better error handling
    - _Bug_Condition: isBugCondition(input) where input.hasImageFile == true AND backendResponse.isValidJSON() == false_
    - _Expected_Behavior: Frontend SHALL provide clear error messages when JSON parsing fails_
    - _Preservation: All other API calls must continue to work correctly_
    - _Requirements: 2.1, 2.4_

  - [~] 3.6 Verify bug condition exploration test now passes
    - **Property 1: Expected Behavior** - Valid JSON Response for Product Upload with Image
    - **IMPORTANT**: Re-run the SAME test from task 1 - do NOT write a new test
    - The test from task 1 encodes the expected behavior
    - When this test passes, it confirms the expected behavior is satisfied
    - Run bug condition exploration test from step 1
    - **EXPECTED OUTCOME**: Test PASSES (confirms bug is fixed)
    - _Requirements: 2.1, 2.4_

  - [~] 3.7 Verify preservation tests still pass
    - **Property 2: Preservation** - Non-Multipart Operations Unchanged
    - **IMPORTANT**: Re-run the SAME tests from task 2 - do NOT write new tests
    - Run preservation property tests from step 2
    - **EXPECTED OUTCOME**: Tests PASS (confirms no regressions)
    - Confirm all tests still pass after fix (no regressions)
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

- [~] 4. Checkpoint - Ensure all tests pass
  - Verify bug condition exploration test passes (product upload with image returns valid JSON)
  - Verify preservation tests pass (non-multipart operations unchanged)
  - Test full product upload flow from frontend form to database
  - Test error cases: large images, invalid file types, missing fields
  - Test concurrent uploads and special characters in product data
  - Ask the user if questions arise
