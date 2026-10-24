import httpx
import pymupdf as fitz

def create_pdf(text: str) -> bytes:
    doc = fitz.open()
    page = doc.new_page()
    page.insert_text((50, 72), text)
    b = doc.tobytes()
    doc.close()
    return b

def test_live_multi_domain():
    url = "http://127.0.0.1:8000/api/v1/analyze-resume"
    
    domains = [
        {
            "name": "Civil Engineering",
            "resume": "Civil Engineer with 5 years experience in AutoCAD, site safety management, concrete testing, and land surveying.",
            "title": "Structural Project Engineer",
            "jd": "Requirements: AutoCAD, STAAD.Pro, Structural Analysis, Geotechnical Engineering, and Revit.",
        },
        {
            "name": "Animation & 3D Media",
            "resume": "Animator experienced in Blender, storyboarding, 3D modeling, and keyframing.",
            "title": "Lead 3D Animator",
            "jd": "Seeking Senior Animator proficient in Maya, Blender, character rigging, motion graphics, and Adobe After Effects.",
        },
        {
            "name": "Healthcare & Nursing",
            "resume": "Registered Nurse with emergency room experience. Expert in Patient Triage, Vital Signs Monitoring, and BLS Certification.",
            "title": "ICU Staff Nurse",
            "jd": "We require Patient Triage, ACLS Certification, EHR/EMR Charting, HIPAA Compliance, and Pharmacology knowledge.",
        },
    ]

    with httpx.Client(timeout=30) as client:
        for d in domains:
            print(f"\n=== Testing Domain: {d['name']} ===")
            pdf_bytes = create_pdf(d["resume"])
            files = {"resume": ("resume.pdf", pdf_bytes, "application/pdf")}
            data = {"job_title": d["title"], "job_description": d["jd"]}
            resp = client.post(url, files=files, data=data)
            print(f"Status: {resp.status_code}")
            if resp.status_code == 200:
                body = resp.json()
                print(f"Match Score: {body['match_score']}%")
                print("Matched Skills:", [s['name'] for s in body.get('matched_skills', [])])
                print("Potential Gaps:", [s['name'] for s in body.get('potential_missing_skills', [])])
                print("Recommendations:", [f"{r['skill']}: {r['recommendation'][:60]}..." for r in body.get('recommendations', [])[:2]])
            else:
                print("Error:", resp.text)

if __name__ == "__main__":
    test_live_multi_domain()

