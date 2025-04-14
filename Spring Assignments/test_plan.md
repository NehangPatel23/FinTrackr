# Test Plan

## Description of Test Plan

Our method involves testing the application in three parts:

1. **UI Testing**: We begin by testing the user interface (UI) components separately, including all front-end processes and functionalities.

2. **Backend Monitoring**: While front-end testing is underway, we monitor the backend to ensure proper data storage and transfer.

3. **Production Testing**: We then perform stress testing on the production version of the application to assess system performance under real-world conditions.

Every test will be executed normally, with anomalies noted and addressed appropriately.

## Test Case Descriptions

### 1. Expenses Testing

- **Purpose**: Ensure functionality of the Expense page under normal and abnormal conditions.
- **Test Cases**:
  - 1.2.1: Update balance through "Add Expense" and "Income" buttons.
  - 1.2.2: Test for abnormalities by entering unusual amounts.
  - 1.2.3: Test OCR functionality with bill images.
  - 1.2.4: Use irrelevant images to test API behavior.
- **Inputs**: Normal and abnormal values (e.g., expenses, images).
- **Expected Outputs**: Error pop-ups may appear, but the app should not crash.
- **Test Types**:
  - Normal/Abnormal
  - Blackbox
  - Functional
  - Integration

### 2. Add Expense Testing

- **Purpose**: Verify individual components of the "Add Expense" feature.
- **Test Cases**:
  - 2.2.1 to 2.2.5: Test with normal/abnormal amounts, new categories, and date inputs.
- **Inputs**: Normal and abnormal values.
- **Expected Outputs**: Functional app with error messages where necessary.
- **Test Types**:
  - Normal/Abnormal
  - Blackbox
  - Functional
  - Integration

### 3. Transactions Testing

- **Purpose**: Validate transaction graph updates based on user data.
- **Test Cases**:
  - 3.2.1: Add multiple expenses across categories/dates.
  - 3.2.2: Verify accuracy of the transaction graph.
- **Inputs**: Normal and abnormal values.
- **Expected Outputs**: Accurate graphical display; no crashes.
- **Test Types**:
  - Normal/Abnormal
  - Blackbox
  - Functional
  - Integration

### 4. Menu Test

- **Purpose**: Check navigation across app sections.
- **Test Cases**:
  - 4.1.1: Test "+" and back button functionality.
  - 4.1.2: Navigate between pages to test links.
- **Inputs**: Button clicks.
- **Expected Outputs**: Correct navigation and error pop-ups if needed.
- **Test Types**:
  - Normal/Abnormal
  - Blackbox
  - Functional
  - Integration

### 5. Debt Testing

- **Purpose**: Validate Debt page calculations and graphical updates.
- **Test Cases**:
  - 5.1.1: Input normal values and submit.
  - 5.1.2: Input negative/invalid values.
  - 5.1.3: Manually alter calculated values.
- **Inputs**: Normal and abnormal values.
- **Expected Outputs**: Updated graphs; error messages for invalid inputs.
- **Test Types**:
  - Normal
  - Whitebox
  - Performance
  - Unit

### 6. Stocks Page Testing

- **Purpose**: Test features and UI components of the Stocks page.
- **Test Cases**:
  - 6.1.1 to 6.1.5: Test favorites, stock info, graphs, and knowledge section.
- **Inputs**: Button clicks.
- **Expected Outputs**: Updated graphs; no crashes.
- **Test Types**:
  - Normal
  - Whitebox
  - Performance
  - Unit

### 7. Tax Page Testing

- **Purpose**: Verify tax calculations and graphical representations.
- **Test Cases**:
  - 7.1.1 to 7.1.3: Test different values for income, dependents, etc.
- **Inputs**: Normal and abnormal values.
- **Expected Outputs**: Updated tax graphs and values; error handling.
- **Test Types**:
  - Normal
  - Whitebox
  - Performance
  - Unit

## Overall Test Case Matrix

| Test Case ID | Normal/Abnormal | Box Type  | Function/Performance | Level        |
|--------------|------------------|-----------|-----------------------|--------------|
| 1            | Abnormal         | Blackbox  | Performance           | Unit         |
| 2            | Abnormal         | Blackbox  | Function              | Integration  |
| 3            | Abnormal         | Blackbox  | Function              | Unit         |
| 4            | Abnormal         | Blackbox  | Function              | Integration  |
| 5            | Normal           | Whitebox  | Performance           | Unit         |
| 6            | Normal           | Whitebox  | Performance           | Unit         |
| 7            | Normal           | Whitebox  | Performance           | Unit         |

## Test Results

All the tests described above were executed successfully, either on the first attempt or after fixing minor bugs. Below is a summary of the outcomes:

| Test Case ID | Status     | Notes                                    |
|--------------|------------|------------------------------------------|
| 1            | Passed     | Some minor OCR API bugs were fixed       |
| 2            | Passed     | Handled abnormal input cases successfully |
| 3            | Passed     | Graph updates validated as expected      |
| 4            | Passed     | Navigation bugs fixed during testing     |
| 5            | Passed     | Error messages triggered correctly       |
| 6            | Passed     | Dynamic updates and graph rendering fine |
| 7            | Passed     | Tax calculations accurate after fix      |

All components of the application are functioning as intended after these validations.
