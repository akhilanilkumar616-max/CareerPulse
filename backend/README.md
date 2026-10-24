# CareerPulse AI Resume Analysis Backend

FastAPI-powered intelligence service for extracting, normalizing, and semantically matching resume skills against job requirements for the CareerPulse application.

---

## 1. System Overview

The CareerPulse AI backend processes candidate PDF resumes and target job descriptions to identify skill alignment, partial competencies, and potential skill gaps.

### Key Capabilities:
* **PDF Processing:** Secure in-memory PDF parsing and text normalization via PyMuPDF (`fitz`), rejecting corrupt files and image-only scanned PDFs without OCR layers.
* **Skill Taxonomy & NLP Extraction:** High-accuracy boundary regex and taxonomy matching across 6 technical domains (Languages, Web, AI/Data, Databases, Cloud/DevOps, Software Engineering).
* **Skill Normalization:** Automatic resolution of acronyms and aliases (e.g. `JS` → `JavaScript`, `K8s` → `Kubernetes`, `OOP` → `Object-Oriented Programming`) with safe separation of distinct languages (Java vs JavaScript, C vs C++).
* **Semantic Matching:** Pre-trained Sentence Transformers (`all-MiniLM-L6-v2`) computing cosine similarity between candidate skills and job requirements.
* **Transparent Scoring:** Explainable mathematical formulation:
  $$\text{Match Score} = \left(\frac{\text{Matched} + 0.5 \times \text{Partial}}{\text{Total Required}}\right) \times 100$$
* **Personalized Recommendations:** Targeted preparation advice directly mapped to identified skill gaps.

---

## 2. API Endpoints

### 1. Health Check
* **Route:** `GET /api/v1/health`
* **Response:**
  ```json
  {
    "status": "ok",
    "service": "career-pulse-analysis"
  }
  ```

### 2. Resume & Skill Gap Analysis
* **Route:** `POST /api/v1/analyze-resume`
* **Content-Type:** `multipart/form-data`
* **Form Parameters:**
  * `resume`: Candidate PDF file (`application/pdf`, max 5 MB).
  * `job_title`: Target job role name (e.g., `Frontend Developer`).
  * `company_name`: (Optional) Hiring company name.
  * `job_description`: Full text of the target job description (min 30 characters).
* **Response Example:**
  ```json
  {
    "job_title": "Frontend Developer",
    "match_score": 75,
    "matched_skills": [
      {
        "name": "HTML",
        "status": "matched",
        "resume_evidence": "Developed responsive user interfaces using HTML and CSS."
      },
      {
        "name": "JavaScript",
        "status": "matched",
        "resume_evidence": "Proficient in JavaScript ES6+ and modern web architectures."
      }
    ],
    "partial_skills": [
      {
        "name": "React",
        "status": "partial",
        "resume_evidence": "Experienced with JavaScript frontend libraries.",
        "reason": "Related competency identified in JavaScript, but exact requirement for React needs verification."
      }
    ],
    "potential_missing_skills": [
      {
        "name": "REST APIs",
        "status": "potential_gap",
        "reason": "The skill was required in the job description but was not identified in the resume."
      }
    ],
    "recommendations": [
      {
        "skill": "REST APIs",
        "recommendation": "Study HTTP status codes, verbs (GET, POST, PUT, DELETE), request/response headers, and API documentation with OpenAPI/Swagger."
      }
    ],
    "summary": "Strong skill alignment for Frontend Developer..."
  }
  ```

---

## 3. Local Setup & Execution

### Prerequisites
* Python 3.10+ (tested on Python 3.13)
* Windows, macOS, or Linux

### Virtual Environment Setup
```bash
# Navigate to backend directory
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
.\venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### Running the Server
```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```
Interactive API docs (Swagger UI) will be available at:
`http://127.0.0.1:8000/docs`

---

## 4. Running Backend Unit Tests

Execute the automated test suite covering PDF validation, text extraction, skill normalization, matching, score calculation, and API routes:

```bash
pytest tests/test_analysis.py -v
```
