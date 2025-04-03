# FinTrackr

FinTrackr is a comprehensive personal finance management app designed to help users track their expenses, monitor subscriptions, set budgeting goals, and receive personalized stock market investment recommendations.

## Table of Contents

- [FinTrackr](#fintrackr)
  - [Table of Contents](#table-of-contents)
  - [Team Budgeteers](#team-budgeteers)
    - [Team Advisor](#team-advisor)
    - [Team Members](#team-members)
  - [Project Abstract](#project-abstract)
  - [Project Description](#project-description)
  - [User Stories](#user-stories)
  - [Design Diagrams](#design-diagrams)
    - [D0](#d0)
    - [D1](#d1)
    - [D2](#d2)
  - [Project Tasks \& Timeline](#project-tasks--timeline)
    - [Nehang's Tasks](#nehangs-tasks)
    - [Tharun's Tasks](#tharuns-tasks)
    - [Shruti's Tasks](#shrutis-tasks)
    - [Timeline](#timeline)
    - [Effort Matrix](#effort-matrix)
      - [Effort Scoring](#effort-scoring)
  - [ABET Concerns](#abet-concerns)
  - [Fall Design Presentation](#fall-design-presentation)
  - [Self Assessments](#self-assessments)
  - [Professional Biographies](#professional-biographies)
  - [Budget](#budget)
  - [Features](#features)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
  - [Usage](#usage)
    - [Home Screen](#home-screen)
    - [Adding Expenses](#adding-expenses)
  - [Contact](#contact)
  - [Appendix](#appendix)
    - [Semester-wide efforts for each team member](#semester-wide-efforts-for-each-team-member)

## Team Budgeteers

### Team Advisor

- Dr. Nitin Nitin

### Team Members

- Nehang Patel

- Shruti Asolkar

- Tharun Swaminathan Ravi Kumar

## Project Abstract

This project develops a personal finance app to help users manage expenses, track debt, and improve budgeting. It also offers stock market investment tips tailored to user preferences and financial habits. By integrating expense tracking, financial planning, and investment strategies, the app provides a holistic tool for effective personal finance management.

## Project Description

This project centers on creating a comprehensive personal finance application designed to empower users in managing their financial well-being. The application offers a user-friendly **Expense Tracker Landing Page** as the main interface, allowing users to efficiently manage and review their expenses. Key features include:

1. **Expense Management:**
   - Users can easily **add new expenses** via a form or through **OCR technology** for scanning receipts.
   - A dedicated **View Expenses** feature helps users track spending and identify patterns to improve financial habits.

2. **Stock Management:**
   - The app includes a **Stocks module** offering:
     - **Educational content** to help users understand investment strategies.
     - Options to **save favorite stocks** for quick access.
     - Tools to **view stock trends**, enabling informed decision-making.

3. **Debt Tracking:**
   - A **Debt module** provides insights into:
     - **Outstanding debt and interest calculations**.
     - A **visual representation of monthly payments** using pie charts, simplifying debt management for users.

4. **Tax Calculation:**
   - The app integrates a **Tax Calculator** to guide users through tax planning, featuring:
     - Input fields for **number of dependents**, **annual income**, and **state of residence**.
     - Insights into **tax treaties** and regulations to ensure compliance.
     - Outputs **tentative state and federal tax calculations** to assist users with their tax obligations.

By combining these features, the app offers a **holistic personal finance tool** that blends daily expense management with long-term financial planning. The seamless integration of expense tracking, stock investment insights, debt monitoring, and tax planning equips users with the tools they need for a secure financial future.

## User Stories

We have identified the following User Stories for our app, FinTrackr:

1. As a **college student**, I want to manage my daily expenses along with my income so that I can save enough money for personal use, college and emergencies.
2. As a **9-5 working professional**, I want to stay informed about current stock trends so that I can make well-informed investments in stocks based on a detailed analysis by the application.
3. As a **freelancer**, I want to make passive income through investments while also learning about effective stock-trading strategies so that I can maintain a stable household income.
4. As a **debt-repayer**, I want to keep tracks of my debts, and set savings goals to repay all of my debts in time.

## Design Diagrams

### D0

![alt text](./Design%20Diagrams/Design_Diagram_D0.png)

The flowchart illustrates a simple user interaction process. It starts with the user deciding whether to utilize the application (decision point). If they do, the application generates an output that is displayed on the UI, concluding with the end of the user flow. The process follows a straightforward, linear path.

### D1

![alt text](./Design%20Diagrams/Design_Diagram_D1.png)

The diagram represents the user flow and system architecture for a personal finance management application, detailing the purpose of its components and conventions used. Rounded rectangles indicate the start and end of the user interaction flow, representing the entry and exit points of the system. Ellipses or ovals represent the primary modules that users interact with, such as "Stocks," "Add Expense," "Tax Calculator," and "Debt." Rectangles signify specific actions or functionalities within these modules, such as stock visualization, keeping track of expenses, inputting tax information, and accessing debt-related data. Arrows illustrate the flow of user interactions, connecting the components and guiding users through the application. The flow begins with the "Expense Tracker Landing Page," which serves as the central navigation hub, leading to different modules based on user needs. Each module outputs its data to the "Display on UI" component, which consolidates and presents information in a user-friendly format. The process concludes with the "User Flow End," marking the completion of the interaction. This diagram ensures a streamlined and intuitive navigation experience, with each component designed to enhance user accessibility and functionality while supporting effective financial management.

### D2

![alt text](./Design%20Diagrams/Design_Diagram_D2.png)

The diagram illustrates the flow and structure of our comprehensive personal finance management application, highlighting its components and conventions.

- **Rounded Rectangles:** Represent the start and end points of user interactions, such as entering or exiting the system.
- **Ellipses/Ovals:** Depict individual pages users interact with, including features like viewing expenses, adding new entries, and navigating financial tools.
- **Rectangles:** Represent major modules, such as Debt Management, Stock Management, and the Tax Calculator, acting as central hubs for related functionalities.
- **Circles:** Highlight specific actions or functionalities available on each page, such as calculating taxes or saving favorite stocks.
- **Parallelograms (in D1):** Indicate how particular pages are utilized.
- **Arrows:**
  - Solid arrows show the flow of user interactions.
  - Dotted arrows are used to avoid visual overlap and enhance clarity.

Key features illustrated in the diagram include:

- **OCR Module:** Scans receipts for automatic data extraction.
- **Debt Management Pie Chart:** Visualizes monthly payments for better understanding.
- **Stock Monitoring Tools:** Help users track trends and save favorite stocks.
- **Tax Calculator:** Estimates federal and state taxes based on user inputs.

The diagram integrates these components seamlessly, conveying a clear and user-friendly structure for the application. Each component is designed to enhance financial literacy, support informed decision-making, and improve the overall user experience.

## Project Tasks & Timeline

### Nehang's Tasks

1. Refine the "Add Expenses" page and add a section to make notes about a transaction.
2. Design and develop the "Stocks" page UI.
3. Design and develop the UI for the "Debt" page.
4. Research and develop a list of debt-repayment educational content for the "Debt" page.
5. Implement user authentication for logging in/out or creating user accounts.

### Tharun's Tasks

1. Research, design, and develop the logic and code for OCR under the "Add Expenses" section.
2. Develop the mathematical formula and visualizations for the "Debt" page.
3. Develop the database API to pull data about tax percentages based on user inputs on the "Taxes" page.
4. Testing and Quality Assurance during development.
5. Implement the user account linking from the backend and updating the frontend based on it.

### Shruti's Tasks

1. Research stock trends and educational content for the "Stocks" page.
2. Design and implement pages for the different pending parts of the app.
3. Design the form for the "Tax Calculator" page.
4. Research chatbot integrations for the app.
5. Research and implement in-app notifications.

### Timeline

The provided timeline outlines the start and end dates for each task related to the milestones. It helps our team stay organized and ensures timely completion of project components.

|**Task**                                                                                      | **Start** | **End**   |
|------------------------------------------------------------------------------------------------|-----------|-----------|
| Refine the "Add Expenses" page and add a section to make notes about a transaction.    |   20 October 2024        |  23 October 2024         |
| Research the logic for OCR under "Add Expenses" section.  | 21 October 2024          |  26 October 2024         |
| Research stock trends and educational content for the "Stocks" page.                   |  20 October 2024         |    23 October 2024       |
| Design and develop the "Debt" page UI.                                                |     23 October 2024      |     31 October 2024      |
| Develop the mathematical formula and visualizations for the "Debt" page.               |   01 November 2024      |     10 November 2024      |
| Design and implement pages for the different pending parts of the app.                 |     24 October 2024      |     01 November 2024      |
| Design and develop the UI for the "Stocks" page.                                         |     01 November 2024      |      11 November 2024     |
| Design the form for the "Tax Calculator" page.                                          |     02 November 2024      |      12 November 2024     |
| Develop the database API to pull data about tax percentages based on user inputs on the "Taxes" page. |      13 November 2024     |     17 November 2024      |
| Research and develop list of debt-repayment educational content for the "Debt" page.    |     15 January 2025      |     19 January 2025      |
| Design and develop the logic and code for OCR under "Add Expenses" section.  | 20 January 2025          |  31 January 2025         |
| Research and implement in-app notifications.                                            |     15 January 2025      |      30 January 2025     |
| Research chatbot integrations for the app.                                              |      01 February 2025     |      10 February 2025     |
| Implement user authentication for logging in/out or creating user accounts.            |      20 January 2025     |      25 January 2025     |
| Implement user account linking from backend and update frontend based on it.           |      25 January 2025     |     15 February 2025      |
| Testing and Quality Assurance during development.                                      |    01 November 2024      |     28 February 2025      |

<br>

### Effort Matrix

The Effort Matrix outlines the tasks assigned to each team member, their associated effort scores, and the corresponding milestones. It provides a clear overview of who is responsible for what, making project management more efficient.

<br>

| **Team Member** | **Task**                                                                                      | **Effort (1-5)** | **Milestone**                                        |
|-----------------|------------------------------------------------------------------------------------------------|------------------|-----------------------------------------------------|
| **Nehang**      | Refine the "Add Expenses" page and add a section to make notes about a transaction.             | 3                | Development of "Add Expenses" page - OCR            |
|                 | Design and develop the UI for the "Stocks" page.                                                | 4                | Development of "Stocks" page - APIs, Notifications  |
|                 | Design and develop the UI for the "Debt" page.                                                  | 5                | Development of "Debt" page - Visualizations         |
|                 | Implement user authentication for logging in/out or creating user accounts.                     | 4                | Authentication and user persona development         |
|                 | Research and develop list of debt-repayment educational content for the "Debt" page.            | 3                | Development of "Debt" page - Visualizations         |
|                 | Testing and Quality Assurance during development (contribution).                                | 2                | Ongoing                                             |
| **Total Effort**|                                                                                                | **21**           |                                                     |

| **Team Member** | **Task**                                                                                      | **Effort (1-5)** | **Milestone**                                        |
|-----------------|------------------------------------------------------------------------------------------------|------------------|-----------------------------------------------------|
| **Tharun**      | Research, design, and develop the logic and code for OCR under "Add Expenses" section.           | 5                | Development of "Add Expenses" page - OCR            |
|                 | Develop the mathematical formula and visualizations for the "Debt" page.                        | 5                | Development of "Debt" page - Visualizations         |
|                 | Develop the database API to pull data about tax percentages based on user inputs on the "Taxes" page. | 4           | Development of "Tax" page - database APIs           |
|                 | Implement user account linking from backend and update frontend based on it.                    | 4                | Authentication and user persona development         |
|                 | Testing and Quality Assurance during development.                                               | 3                | Ongoing                                             |
| **Total Effort**|                                                                                                | **21**           |                                                     |

| **Team Member** | **Task**                                                                                      | **Effort (1-5)** | **Milestone**                                        |
|-----------------|------------------------------------------------------------------------------------------------|------------------|-----------------------------------------------------|
| **Shruti**      | Research stock trends and educational content for the "Stocks" page.                             | 3                | Development of "Stocks" page - APIs, Notifications  |
|                 | Design and implement pages for the different pending parts of the app.                           | 4                | Ongoing                                             |
|                 | Design the form for the "Tax Calculator" page.                                                   | 3                | Development of "Tax" page - database APIs           |
|                 | Research and implement in-app notifications.                                                     | 4                | Development of "Stocks" page - APIs, Notifications  |
|                 | Research chatbot integrations for the app.                                                       | 4                | Ongoing                                             |
|                 | Testing and Quality Assurance during development(Contribution).                                               | 3                | Ongoing                                             |
| **Total Effort**|                                                                                                | **21**           |                                                     |

#### Effort Scoring

The effort scoring system categorizes tasks based on the complexity and workload involved, ranging from straightforward research (1) to complex backend development (5). This system helps our team assess and prioritize tasks based on our effort requirements.

**1**: Low effort, typically research or straightforward tasks. <br>
**2**: Slightly more effort, usually involving design or basic implementation. <br>
**3**: Moderate effort, including UI design or educational content research. <br>
**4**: High effort, typically involving API integration or backend development. <br>
**5**: Very high effort, including logic-heavy tasks like developing  visualizations or complex backend code.

## ABET Concerns

In designing FinTrackr, our comprehensive personal finance management app, we must navigate several constraints that could impact our solutions.

**Economically**, we face financial limitations as our development relies on free and open-source tools to manage our budget effectively. Since our funding primarily comes from personal resources, we are restricted in purchasing premium software or services, which could limit certain advanced functionalities. However, leveraging free resources could also promote accessibility for our target users, potentially contributing to economic development by enhancing their financial literacy and decision-making capabilities. We hope to reserve premium features for a future time when we have the appropriate budget for it.

**Legally**, the project must comply with various regulations concerning intellectual property and user data privacy. As FinTrackr integrates third-party APIs for features such as stock market recommendations and subscription tracking, we need to ensure that our use of these APIs adheres to licensing agreements and avoids infringing on existing intellectual property. Additionally, as our application will handle sensitive financial information, it is crucial to comply with data protection laws such as GDPR and CCPA to safeguard user privacy and build trust.

**Socially**, FinTrackr aims to serve a significant public interest by providing users with tools to improve their financial literacy and overall quality of life. Our project is particularly focused on empowering users to manage their finances more effectively, which can lead to better financial habits and less economic stress. Collaborating with non-profit organizations may enhance our outreach to underserved communities, ensuring that the benefits of our app reach those who need financial assistance the most. By addressing these constraints, we hope to develop a responsible and impactful solution that not only simplifies personal finance management but also fosters long-term financial well-being for our users.

## Fall Design Presentation

**Slides:** This is the link to our [slides](https://mailuc-my.sharepoint.com/:p:/g/personal/patel3ng_mail_uc_edu/EUW-Ynnd3G1Hlvm8HzOlyekBmeySR_yU_paeXQiF9GEehA?e=CgVDmA).

**Video:** This is the link to our [presentation video](https://mailuc-my.sharepoint.com/personal/patel3ng_mail_uc_edu/_layouts/15/stream.aspx?id=%2Fpersonal%2Fpatel3ng%5Fmail%5Fuc%5Fedu%2FDocuments%2FFall%20Review%20Presentation%2Emp4&nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&ga=1&referrer=StreamWebApp%2EWeb&referrerScenario=AddressBarCopied%2Eview%2E5fa81b93%2D445b%2D44d3%2D850f%2D98762a933949).

## Self Assessments

[Nehang Patel Self Assessment](./Team%20Contract%20&%20Individual%20Capstone%20Assessments/Markdown%20Versions/Nehang%20Patel%20Individual%20Capstone%20Assessment.md)

[Shruti Asolkar Self Assessment](./Team%20Contract%20&%20Individual%20Capstone%20Assessments/Markdown%20Versions/Shruti%20Asolkar%20Individual%20Capstone%20Assessment.md)

[Tharun Swaminathan Ravi Kumar Self Assessment](./Team%20Contract%20&%20Individual%20Capstone%20Assessments/Markdown%20Versions/Tharun%20Swaminathan%20Individual%20Capstone%20Assessment.md)

## Professional Biographies

[Nehang Patel Professional Biography](./Professional%20Bios/Nehang%20Patel%20Professional%20Biography.md)

[Shruti Asolkar Professional Biography](./Professional%20Bios/Shruti%20Asolkar%20Professional%20Biography.md)

[Tharun Swaminathan Ravi Kumar Professional Biography](./Professional%20Bios/Tharun%20Swaminathan%20Professional%20Biography.md)

## Budget

We have **no budget** for this project. We aim to use open-source and free software and tools for the entirety of the project.

## Features

- User interface built with Flutter for a smooth and responsive experience.
- Ability to add and track expenses - categorized and dated for easier tracking.

## Getting Started

These instructions will help you set up and run the Flutter application locally on your device.

### Prerequisites

- **Flutter SDK:** Make sure you have Flutter installed on your system. You can follow the
  instructions [here](https://flutter.dev/docs/get-started/install) to install Flutter.
- **IDE:** Choose an IDE for Flutter development. Popular choices include Android Studio, Visual
  Studio Code, and IntelliJ IDEA.
- **Git:** Make sure you have [Git](https://git-scm.com/) installed on your device to clone the
  repository. (This step is optional, in case you are downloading the ZIP file or not contributing
  to the repository).

### Installation

**NOTE: Install the Flutter SDK first.**

- If you haven't installed Flutter SDK yet, download it from the
  official [Flutter website](https://docs.flutter.dev/get-started/install).
- Extract the downloaded ZIP file to a location on your computer.
- Add the ```flutter/bin``` directory to your system's PATH to      access the Flutter commands globally.

<br>

1. **Clone this repository:**

    Open your terminal or command prompt and navigate to a directory (If running this app on an iOS device, make sure you clone this repository to a directory that does not sync with the cloud, such as the ```Downloads``` directory) where you want to clone the
    repository. Then, run the following command:

   ```bash
   git clone https://github.com/NehangPatel23/FinTrackr
   ```

<br>

2. **Navigate to the project directory and install the dependencies:**

    Flutter projects have certain dependencies that need to be installed before the application can be
    run. In the project directory, run the following command to install the dependencies specified in
    the ```pubspec.yaml``` file:

    ```bash
    cd fintrackr
    flutter pub get
    ```

3. **Open the project in your IDE.**

    Open your chosen IDE and open the project directory. You can install the Flutter and Dart extensions
    for a smoother development experience.

    For example, if you're using Visual Studio Code, you can open the project by running:

    ```bash
    code .
    ```

4. **Connect a physical device or start an emulator.**

    Ensure that you have either a physical device connected via USB debugging or an emulator running. You can use any device - iOS or Android.

    Note: For iOS devices, the minimum required version to properly run the application is iOS 12.

5. **Run the app:**

    Run the following command to build and launch the app on your connected device or emulator.

    ```bash
    flutter run
    ```

## Usage

***Note: This project currently just focuses on creating the UI and implementing basic dynamic features such as the Transactions List correctly. The app still lacks features such as authentication, adding income to the transactions list, dynamic balance card, etc., which I will implement later.***

### Home Screen

Once you launch the application on your emulator, you will see the following Home Screen:

![alt text](assets/home_screen.png)

The app simulates the expenses for a test user, John Doe.

The Balance Card shows the current balance for the said user, their income and their total expenses.

Below the Balance Card is the Transactions List, that shows all of the user's recent transactions in the form of categories, such as Entertainment, Travel, Food, etc., along with the date on which the transaction occured.

<br>

### Adding Expenses

Clicking on the round ```+``` button next to the ```Home``` button on the bottom navigation bar takes the user to the 'Add Expenses' page:

![alt text](assets/add_expense.png)

Here, the user can add expenses they make and categorize them using the various categories displayed under the 'Categories' menu.

If they are not satisfied with the categories mentioned here, they also have the option to create a new category by clicking the '+' icon on the right side of the Category menu:

![alt text](assets/add_category_incomplete.png)

Here is how this feature works:
    - The user adds a name to the Category, for example, ```Tech```.
    - The user then adds a phone icon to depict the Tech category.
    - Lastly, they add a unique color to identify the category.

This is how the screen would look once they do that:

![alt text](assets/add_category_completed.png)

The newly created category shows up under the Category menu on the previous page:

![alt text](assets/category_menu_new.png)

Now, let's add an expense: Say the user spent $1000 on a laptop today, 25 November 2024.

This is how they would enter it in the app:

![alt text](assets/add_new_expense.png)

Once they click on 'Save', this expense gets added to the Transactions List on the Home Screen:

![alt text](assets/updated_home_page.png)

That's how a user would typically add an expense in the app.

The 'Stats' menu would show the transaction statistics like the spending patterns, which would be depicted as a graph like this:

![alt text](assets/stats.png)

## Contact

If you have any questions, feedback, or suggestions regarding this project, please feel free to
contact us via email at:

- Nehang Patel - <patel3ng@mail.uc.edu>
- Shruti Asolkar - <asolkasy@mail.uc.edu>
- Tharun Swaminathan Ravi Kumar - <ravikutn@mail.uc.edu>.

## Appendix

- Project UI Inspiration - <https://dribbble.com/shots/15560984-Daily-Expense-Tracker>
- Help with BLoC architecture - <https://www.youtube.com/watch?v=pyivtUs4ANo>
- Meeting Notes - **LINK TO COME LATER**

### Semester-wide efforts for each team member

The semester-wide efforts for each team member can be found in the ['Fall Timekeeping' Markdown file](./Fall-Timekeeping.md).
