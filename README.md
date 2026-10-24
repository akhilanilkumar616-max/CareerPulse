# CareerPulse — AI-Powered Career Preparation & Employability Assessment

[![Flutter](https://img.shields.io/badge/Flutter-3.41-02569B?logo=flutter)](https://flutter.dev)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.110+-009688?logo=fastapi)](https://fastapi.tiangolo.com)
[![Python](https://img.shields.io/badge/Python-3.10+-3776AB?logo=python)](https://python.org)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%26%20Firestore-FFCA28?logo=firebase)](https://firebase.google.com)
[![Material 3](https://img.shields.io/badge/Material-3-7B1FA2)](https://m3.material.io)

**CareerPulse** is an AI-powered career preparation and employability assessment system designed for undergraduate students, job seekers, and academic institutions. The platform empowers students to analyze their resumes against real-world job descriptions, evaluate their semantic skill alignment, identify concrete skill gaps, and navigate personalized preparation pathways for aptitude tests and mock interviews.

This repository implements **Phase 1** as a genuine, production-structured academic capstone project.

---

## 1. Phase 1 Architecture & Scope

```
CareerPulse Application Flow:
App Launch ➔ Splash / Initialization ➔ Firebase Auth (Login / Register / Forgot Password)
     ➔ Career Profile Setup ➔ Dashboard (Landing)
           ├─► Module 1: Career Profile (View, Edit Skills & Career Interests)
           ├─► Module 2: Resume Analysis (PDF Upload ➔ FastAPI NLP Pipeline ➔ Skill Gap Report)
           ├─► Module 3 (Phase 2 Placeholder): Mock Session (Aptitude & Interview Setup)
           └─► Module 4: Assessment History (Saved Firestore Analysis Records)
```

### Implemented Modules:
1. **Module 1: User Authentication & Career Profile**
   * Firebase Authentication with email/password, sign in, registration, session persistence, and password reset.
   * Multi-field Career Profile in Cloud Firestore (`users/{uid}`) storing education level, institution, degree, specialization, graduation year, custom skills list, target career interests, and professional summary.
   * Profile view, inline skill chips addition/removal, and editing with persistence.
2. **Module 2: Resume Analysis & Skill Gap Analysis**
   * Real PDF resume upload (up to 5 MB) with file validation and rejection of image-only scanned PDFs without OCR.
   * Target role and job description entry with character validation.
   * Full end-to-end integration with FastAPI backend (`/api/v1/analyze-resume`).
   * PyMuPDF (`fitz`) text extraction and whitespace/token normalization.
   * NLP extraction across 6 skill taxonomy domains with aliases and normalization.
   * Semantic matching using Sentence Transformers (`all-MiniLM-L6-v2`) and cosine similarity.
   * Transparent math formula:
     $$\text{Estimated Skill Match Score} = \left(\frac{\text{Matched} + 0.5 \times \text{Partial}}{\text{Total Required}}\right) \times 100$$
   * Actionable gap report: Matched skills with evidence snippets, partial competencies ("Needs Verification"), potential skill gaps with non-judgmental wording, and targeted recommendations.
   * Automatic report persistence to Firestore (`users/{uid}/assessmentResults/{resultId}`).
3. **Navigable Placeholder Modules (Prepared for Phase 2)**
   * **Mock Session Setup:** Validates previous analysis, allows difficulty selection (Easy, Medium, Hard), and routes to preparation modules.
   * **Aptitude Test:** Dedicated themed placeholder page with navigation.
   * **Mock Interview:** Dedicated technical interview question list & live interview placeholders.
   * **Assessment History:** Dedicated page listing all previous analysis records with match score badges and full report reopening.

---

## 2. Official Visual Identity & Design System

The application strictly implements the global color palette across **every screen, dialog, card, and component**:

| Element | Hex Code | Purpose |
|---|---|---|
| **Dark Navy** | `#172C43` | Headings, primary brand identity, active dark accents |
| **Deep Blue** | `#245B86` | Subheadings, section titles, secondary brand elements |
| **Primary Blue** | `#078AC4` | Primary action buttons, active indicators, focus rings |
| **Teal** | `#12A69B` | Secondary buttons, matched skills, success indicators |
| **Light Blue Background** | `#F2F7FC` | Global scaffold background, subtle contrast |
| **White** | `#FFFFFF` | Card surfaces, modal dialogs, input field fills |
| **Primary Text** | `#1C2D40` | Body typography, input labels, readable text |
| **Secondary Text** | `#46576A` | Helper labels, captions, metadata |
| **Border Color** | `#E0E8F0` | Subtle clean card and container borders |

---

## 3. Project Directory Structure

```
careerpulseapp/
├── lib/
│   ├── main.dart                       # App entry point & Firebase initialization
│   ├── app.dart                        # MultiProvider root & MaterialApp.router
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart      # Breakpoints, file limits, asset paths
│   │   │   └── api_constants.dart      # Multi-platform backend URLs (Android/Web/Desktop)
│   │   ├── routing/
│   │   │   └── app_router.dart         # GoRouter with authentication route guards
│   │   ├── theme/
│   │   │   ├── app_colors.dart         # Official CareerPulse color palette
│   │   │   └── app_theme.dart          # Centralized Material 3 ThemeData
│   │   └── utils/
│   │       ├── responsive.dart         # Mobile (<650), Tablet, Desktop (>1024) helper
│   │       └── validators.dart         # Form validation rules
│   ├── models/
│   │   ├── user_profile.dart           # User profile entity with Firestore serialization
│   │   ├── skill.dart                  # SkillMatch & SkillRecommendation models
│   │   └── analysis_result.dart        # Complete assessment report entity
│   ├── providers/
│   │   ├── auth_provider.dart          # Authentication state & user session
│   │   ├── profile_provider.dart       # Career profile management & chips
│   │   └── analysis_provider.dart      # Resume file, FastAPI dispatch & history
│   ├── services/
│   │   ├── auth_service.dart           # Firebase Auth API & error mapping
│   │   ├── firestore_service.dart      # Cloud Firestore persistence
│   │   ├── resume_service.dart         # PDF picker & file size validation
│   │   └── api_service.dart            # Multipart HTTP client for FastAPI backend
│   ├── screens/
│   │   ├── splash/                     # Branded splash & auth redirect
│   │   ├── auth/                       # Login, Register, Forgot Password
│   │   ├── profile/                    # Profile setup & Profile view/edit
│   │   ├── dashboard/                  # Landing dashboard with 3 feature cards & recent items
│   │   ├── resume_analysis/            # Resume upload form & detailed report screen
│   │   ├── mock_session/               # Difficulty selection & session setup
│   │   ├── aptitude/                   # Aptitude test placeholder
│   │   └── interview_history/          # Assessment history listing
│   └── widgets/
│       ├── app_button.dart             # Primary, secondary, outline themed buttons
│       ├── app_text_field.dart         # Standard input field with icons & validation
│       ├── app_header.dart             # Header with logo, user menu, navigation
│       ├── feature_card.dart           # Dashboard module card with icon & action
│       ├── loading_indicator.dart      # Branded spinner with message
│       └── responsive_layout.dart      # Centered max-width container
│
├── backend/
│   ├── main.py                         # FastAPI application entry & CORS middleware
│   ├── requirements.txt                # Python dependencies
│   ├── .env.example                    # Backend environment template
│   ├── README.md                       # Backend documentation & API spec
│   ├── api/routes/
│   │   ├── health.py                   # GET /api/v1/health
│   │   └── analysis.py                 # POST /api/v1/analyze-resume
│   ├── models/
│   │   └── schemas.py                  # Pydantic request & response schemas
│   ├── services/
│   │   ├── pdf_extractor.py            # PyMuPDF text extraction & validation
│   │   ├── skill_extractor.py          # Taxonomy & NLP skill extraction
│   │   └── skill_matcher.py            # SentenceTransformers & cosine similarity
│   └── tests/
│       └── test_analysis.py            # Automated unit tests for backend pipeline
│
├── assets/
│   └── images/
│       └── logo.png                    # Official CareerPulse logo
├── test/
│   └── widget_test.dart                # Flutter widget smoke tests
├── pubspec.yaml                        # Flutter package configuration
└── README.md                           # Master project documentation
```

---

## 4. Getting Started

### 4.1 Prerequisites
* [Flutter SDK 3.20+](https://docs.flutter.dev/get-started/install) (Dart 3.5+)
* [Python 3.10+](https://www.python.org/downloads/)
* [Git](https://git-scm.com/)

---

### 4.2 Backend Setup & Execution

1. Navigate to the `backend` folder:
   ```bash
   cd backend
   ```
2. Create and activate a Python virtual environment:
   ```bash
   # Windows:
   python -m venv venv
   .\venv\Scripts\activate

   # macOS / Linux:
   python3 -m venv venv
   source venv/bin/activate
   ```
3. Install required Python packages:
   ```bash
   pip install -r requirements.txt
   ```
4. Start the FastAPI development server:
   ```bash
   uvicorn main:app --host 0.0.0.0 --port 8000 --reload
   ```
5. Confirm backend health:
   * Browser or curl: `http://127.0.0.1:8000/api/v1/health`
   * Interactive Swagger UI: `http://127.0.0.1:8000/docs`

---

### 4.3 Flutter Frontend Setup & Execution

1. In the project root directory, install Flutter packages:
   ```bash
   flutter pub get
   ```
2. Run on your desired platform:
   * **Chrome / Web:**
     ```bash
     flutter run -d chrome
     ```
   * **Windows Desktop:**
     ```bash
     flutter run -d windows
     ```
   * **Android Emulator:**
     ```bash
     flutter run -d android
     ```

#### Multi-Platform Backend Networking Note:
* **Desktop / Web:** Defaults to `http://127.0.0.1:8000`.
* **Android Emulator:** Automatically routes to `http://10.0.2.2:8000` (host loopback alias).
* **Physical Device:** Run with custom backend host override:
  ```bash
  flutter run --dart-define=BACKEND_URL=http://<YOUR_LOCAL_IP>:8000
  ```

---

## 5. Firebase Configuration Guide

CareerPulse uses **Firebase Authentication** for credentials and **Cloud Firestore** for user profiles and assessment histories.

### Steps to Link Your Firebase Project:
1. Create a Firebase project at the [Firebase Console](https://console.firebase.google.com).
2. Enable **Authentication** ➔ Select **Email/Password** as the Sign-in provider.
3. Enable **Cloud Firestore** ➔ Start in **Production Mode**.
4. Configure FlutterFire using the FlutterFire CLI:
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   This generates `firebase_options.dart` and links Android (`google-services.json`), iOS (`GoogleService-Info.plist`), and Web options.

### Firestore Security Rules
Paste these rules in your Firebase Console under **Firestore Database ➔ Rules**:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // User profile document: users/{uid}
    match /users/{userId} {
      allow read, update: if request.auth != null && request.auth.uid == userId;
      allow create: if request.auth != null && request.auth.uid == userId;
      allow delete: if request.auth != null && request.auth.uid == userId;
      
      // Assessment results subcollection: users/{uid}/assessmentResults/{resultId}
      match /assessmentResults/{resultId} {
        allow read: if request.auth != null && request.auth.uid == userId;
        allow create, update: if request.auth != null && request.auth.uid == userId;
        allow delete: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

> **Resilience Mode:** When evaluating the application locally before connecting a live Firebase project, the application automatically handles missing Firebase initialization gracefully with an integrated session layer, allowing full evaluation of the UI, profile management, and the complete FastAPI resume analysis pipeline without crashing.

---

## 6. Automated Testing

### 1. Flutter Tests
Run the Flutter test suite:
```bash
flutter test
```
* **Status:** Passed (1/1 tests passing)
* Validates application widget tree initialization, theme application, and navigation bindings.

### 2. Backend Automated Test Suite
Run the Python pytest suite:
```bash
# Inside backend directory with venv activated:
pytest tests/test_analysis.py -v
```
Covers:
* PDF validation (empty bytes, non-PDF header, scanned image-only PDF detection).
* Text extraction and whitespace normalization.
* Skill normalization mapping and boundary extraction (no false positives like Cat matching C).
* Semantic matching and classification (matched, partial, potential gaps).
* Transparent match score formula calculation.
* Empty/insufficient job description handling.
* FastAPI health and resume analysis API endpoints.

---

## 7. Security, Privacy & Data Handling

* **Temporary Processing:** Resume PDFs are read in-memory to extract text and are immediately released from memory upon analysis completion.
* **No Plaintext Passwords:** Passwords are processed exclusively through Firebase Authentication.
* **Input Validation:** Strict file type validation (`%PDF-` magic bytes verification), maximum file size enforcement (5 MB), and text length validation.
* **Non-Judgmental Language:** Potential gaps are explicitly labeled as "Skills Not Identified in Your Resume" rather than definitive incompetence, reminding candidates to verify their resumes.

---

## 8. Academic Project Deliverable Summary

| Requirement | Implementation Status | Notes |
|---|---|---|
| Responsive Flutter App | Completed | Mobile, Tablet, and Desktop responsive layouts with Material 3 |
| Official Color Palette | Completed | Strictly enforced `#172C43`, `#245B86`, `#078AC4`, `#12A69B`, `#F2F7FC` globally |
| Official Logo Asset | Completed | Integrated in Header, Splash, and Auth screens |
| Firebase Authentication | Completed | Registration, Login, Logout, Password Reset |
| Career Profile in Firestore | Completed | Education, Institution, Degree, Skills, Career Interests, Summary |
| Resume Analysis Form | Completed | PDF file picker, drag & drop, file size validation, JD validation |
| FastAPI Backend | Completed | `/api/v1/health` and `/api/v1/analyze-resume` endpoints |
| PDF Extraction | Completed | PyMuPDF with clean text normalization and scanned PDF detection |
| NLP Skill Extraction | Completed | Curated taxonomy across 6 domains with alias normalization |
| Semantic Matching | Completed | SentenceTransformers `all-MiniLM-L6-v2` with cosine similarity |
| Transparent Match Score | Completed | Mathematical formula based on identified requirements |
| Skill Gap Report | Completed | Matched skills, partial competencies, potential gaps, and recommendations |
| Firestore Persistence | Completed | Analysis results saved under `users/{uid}/assessmentResults/{resultId}` |
| Assessment History Screen | Completed | Real Firestore history retrieval and detailed report reopening |
| Placeholder Modules | Completed | Mock Session setup, Aptitude Test, and Interview placeholders |
| Automated Test Suites | Completed | Flutter widget tests and Python backend pytest suites |
