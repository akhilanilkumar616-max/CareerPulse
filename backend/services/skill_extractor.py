import re
from typing import Dict, List, Set, Tuple


class SkillExtractor:
    """
    Extracts and normalizes technical and domain skills from raw resume
    and job description text using rule-based NLP and taxonomy matching.
    Supports multi-disciplinary tracks including Software, Civil Engineering,
    Animation & Digital Media, Healthcare & Nursing, and Business.
    """

    # Canonical skill taxonomy mapped by categories
    SKILL_TAXONOMY: Dict[str, List[str]] = {
        "programming": [
            "Python", "Java", "C", "C++", "C#", "JavaScript", "TypeScript",
            "Dart", "Go", "Rust", "Kotlin", "Swift", "PHP", "Ruby", "R",
            "SQL", "HTML", "CSS", "Bash", "Shell", "Scala"
        ],
        "web_development": [
            "React", "Angular", "Vue", "Flutter", "Node.js", "Express",
            "Django", "FastAPI", "Flask", "Spring Boot", "ASP.NET", "Next.js",
            "Redux", "REST APIs", "GraphQL", "Tailwind CSS", "Bootstrap",
            "HTML5", "CSS3", "WebSockets"
        ],
        "data_ai": [
            "Machine Learning", "Deep Learning", "Natural Language Processing",
            "Computer Vision", "Data Analysis", "Pandas", "NumPy",
            "Scikit-Learn", "TensorFlow", "PyTorch", "Keras", "Power BI",
            "Tableau", "OpenCV", "Data Visualization", "Big Data", "Spark"
        ],
        "databases": [
            "MySQL", "PostgreSQL", "MongoDB", "Redis", "SQLite", "Firebase",
            "Oracle", "Cassandra", "DynamoDB", "Elasticsearch"
        ],
        "tools_platforms": [
            "Git", "GitHub", "GitLab", "Docker", "Kubernetes", "AWS",
            "Microsoft Azure", "Google Cloud", "CI/CD", "Linux", "Jenkins",
            "Terraform", "Postman", "Jira"
        ],
        "software_engineering": [
            "Object-Oriented Programming", "Data Structures", "Algorithms",
            "Software Testing", "Unit Testing", "Agile Development",
            "Scrum", "Debugging", "System Design", "Microservices"
        ],
        "civil_engineering": [
            "AutoCAD", "STAAD.Pro", "Revit", "Structural Analysis",
            "Site Safety", "Geotechnical Engineering", "Surveying",
            "Concrete Technology", "Estimation & Costing", "Highway Engineering",
            "Construction Management", "Quantity Surveying", "Foundation Engineering",
            "GIS", "Environmental Engineering", "Project Scheduling",
            "Primavera P6", "Building Information Modeling (BIM)", "Steel Structures",
            "Hydrology", "Total Station"
        ],
        "animation": [
            "Blender", "Maya", "3ds Max", "Rigging", "Keyframing",
            "Motion Graphics", "Storyboarding", "Texturing", "Character Animation",
            "After Effects", "Cinema 4D", "ZBrush", "Lighting & Rendering",
            "3D Modeling", "UV Unwrapping", "Concept Art", "Premiere Pro",
            "Compositing", "VFX", "Unreal Engine", "Stop Motion"
        ],
        "nursing": [
            "Patient Triage", "EHR/EMR Charting", "BLS Certification",
            "ACLS Certification", "Pharmacology", "HIPAA Compliance",
            "Vital Signs Monitoring", "Infection Control", "IV Cannulation",
            "Patient Assessment", "Wound Care", "Medication Administration",
            "Medical Terminology", "Phlebotomy", "Critical Care",
            "Clinical Documentation", "CPR", "PALS Certification",
            "Patient Advocacy", "Catheterization"
        ],
        "business_management": [
            "Financial Modeling", "Project Management", "Risk Management",
            "Budgeting", "Microsoft Excel", "Market Research",
            "Strategic Planning", "Accounting", "Business Analysis"
        ],
        "cybersecurity": [
            "Network Security", "Penetration Testing", "SIEM", "Incident Response",
            "Vulnerability Assessment", "OWASP", "Cryptography", "Firewalls",
            "Wireshark", "Threat Analysis", "Identity & Access Management (IAM)",
            "Secure Code Review", "SOC Operations"
        ],
        "finance_accounting": [
            "Financial Modeling", "Valuation", "Accounting", "Risk Management",
            "Budgeting", "Financial Reporting", "Auditing", "Tax Compliance",
            "General Ledger", "Portfolio Management", "Corporate Finance"
        ],
        "product_design": [
            "Figma", "UI/UX Design", "Wireframing", "Prototyping",
            "User Research", "Usability Testing", "Design Systems",
            "Information Architecture", "User Flows", "Interaction Design"
        ],
        "mechanical_engineering": [
            "SolidWorks", "CAD", "Finite Element Analysis (FEA)", "Thermodynamics",
            "GD&T", "Robotics", "PLC Programming", "Control Systems",
            "Embedded C", "ROS", "CNC Machining"
        ],
    }

    # Strict normalization mapping to canonical forms
    NORMALIZATION_MAP: Dict[str, str] = {
        # Tech / Software
        "js": "JavaScript",
        "javascript": "JavaScript",
        "ts": "TypeScript",
        "typescript": "TypeScript",
        "py": "Python",
        "python": "Python",
        "react": "React",
        "reactjs": "React",
        "react.js": "React",
        "node": "Node.js",
        "nodejs": "Node.js",
        "node.js": "Node.js",
        "expressjs": "Express",
        "express.js": "Express",
        "postgres": "PostgreSQL",
        "postgresql": "PostgreSQL",
        "postgresql db": "PostgreSQL",
        "mongo": "MongoDB",
        "mongodb": "MongoDB",
        "k8s": "Kubernetes",
        "kubernetes": "Kubernetes",
        "ml": "Machine Learning",
        "machine learning": "Machine Learning",
        "dl": "Deep Learning",
        "deep learning": "Deep Learning",
        "nlp": "Natural Language Processing",
        "natural language processing": "Natural Language Processing",
        "cv": "Computer Vision",
        "rest api": "REST APIs",
        "rest apis": "REST APIs",
        "restful api": "REST APIs",
        "restful apis": "REST APIs",
        "rest": "REST APIs",
        "oop": "Object-Oriented Programming",
        "oops": "Object-Oriented Programming",
        "object oriented programming": "Object-Oriented Programming",
        "dsa": "Data Structures",
        "data structures and algorithms": "Data Structures",
        "data structure": "Data Structures",
        "data structures": "Data Structures",
        "aws": "AWS",
        "azure": "Microsoft Azure",
        "gcp": "Google Cloud",
        "html5": "HTML",
        "html": "HTML",
        "css3": "CSS",
        "css": "CSS",
        "scikit learn": "Scikit-Learn",
        "sklearn": "Scikit-Learn",
        "spring": "Spring Boot",
        "springboot": "Spring Boot",

        # Civil Engineering
        "autocad": "AutoCAD",
        "auto cad": "AutoCAD",
        "staad pro": "STAAD.Pro",
        "staad.pro": "STAAD.Pro",
        "staad": "STAAD.Pro",
        "revit": "Revit",
        "structural design": "Structural Analysis",
        "structural analysis": "Structural Analysis",
        "structural engineering": "Structural Analysis",
        "geotech": "Geotechnical Engineering",
        "geotechnical": "Geotechnical Engineering",
        "geotechnical engineering": "Geotechnical Engineering",
        "site safety": "Site Safety",
        "site inspection": "Site Safety",
        "safety management": "Site Safety",
        "construction safety": "Site Safety",
        "bim": "Building Information Modeling (BIM)",
        "building information modeling": "Building Information Modeling (BIM)",
        "primavera": "Primavera P6",
        "primavera p6": "Primavera P6",
        "quantity surveying": "Quantity Surveying",
        "estimation": "Estimation & Costing",
        "estimation and costing": "Estimation & Costing",
        "cost estimation": "Estimation & Costing",
        "gis": "GIS",
        "gis mapping": "GIS",
        "concrete tech": "Concrete Technology",
        "concrete technology": "Concrete Technology",

        # Animation & Digital Media
        "3d animation": "Character Animation",
        "character animation": "Character Animation",
        "2d animation": "Character Animation",
        "after effects": "After Effects",
        "adobe after effects": "After Effects",
        "ae": "After Effects",
        "cinema 4d": "Cinema 4D",
        "c4d": "Cinema 4D",
        "key framing": "Keyframing",
        "keyframe": "Keyframing",
        "keyframes": "Keyframing",
        "keyframing": "Keyframing",
        "motion design": "Motion Graphics",
        "motion graphics": "Motion Graphics",
        "3ds max": "3ds Max",
        "3dsmax": "3ds Max",
        "3d max": "3ds Max",
        "zbrush": "ZBrush",
        "z brush": "ZBrush",
        "premiere": "Premiere Pro",
        "adobe premiere": "Premiere Pro",
        "premiere pro": "Premiere Pro",
        "vfx": "VFX",
        "visual effects": "VFX",
        "storyboarding": "Storyboarding",
        "storyboard": "Storyboarding",
        "story boarding": "Storyboarding",
        "3d modeling": "3D Modeling",
        "3d model": "3D Modeling",
        "lighting and rendering": "Lighting & Rendering",
        "lighting & rendering": "Lighting & Rendering",
        "uv mapping": "UV Unwrapping",
        "uv unwrapping": "UV Unwrapping",

        # Healthcare & Nursing
        "bls": "BLS Certification",
        "basic life support": "BLS Certification",
        "bls certification": "BLS Certification",
        "acls": "ACLS Certification",
        "advanced cardiac life support": "ACLS Certification",
        "acls certification": "ACLS Certification",
        "pals": "PALS Certification",
        "cpr": "CPR",
        "cpr certified": "CPR",
        "cpr certification": "CPR",
        "emr": "EHR/EMR Charting",
        "ehr": "EHR/EMR Charting",
        "electronic medical records": "EHR/EMR Charting",
        "electronic health records": "EHR/EMR Charting",
        "emr charting": "EHR/EMR Charting",
        "ehr charting": "EHR/EMR Charting",
        "triage": "Patient Triage",
        "patient triage": "Patient Triage",
        "hipaa": "HIPAA Compliance",
        "hipaa compliance": "HIPAA Compliance",
        "vitals": "Vital Signs Monitoring",
        "vital signs": "Vital Signs Monitoring",
        "vital signs monitoring": "Vital Signs Monitoring",
        "iv therapy": "IV Cannulation",
        "iv cannulation": "IV Cannulation",
        "iv catheter": "IV Cannulation",
        "pharma": "Pharmacology",
        "pharmacology": "Pharmacology",
        "wound care": "Wound Care",
        "wound dressing": "Wound Care",
        "med administration": "Medication Administration",
        "medication administration": "Medication Administration",
        "infection control": "Infection Control",
        "patient assessment": "Patient Assessment",
        "icu care": "Critical Care",
        "critical care": "Critical Care",
        "clinical charting": "Clinical Documentation",
        "clinical documentation": "Clinical Documentation",

        # Business / Management
        "financial modeling": "Financial Modeling",
        "project management": "Project Management",
        "risk management": "Risk Management",
        "excel": "Microsoft Excel",
        "ms excel": "Microsoft Excel",
        "microsoft excel": "Microsoft Excel",
        "business analysis": "Business Analysis",

        # Cybersecurity
        "network security": "Network Security",
        "pentest": "Penetration Testing",
        "pentesting": "Penetration Testing",
        "penetration testing": "Penetration Testing",
        "siem": "SIEM",
        "incident response": "Incident Response",
        "vulnerability assessment": "Vulnerability Assessment",
        "vulnerability management": "Vulnerability Assessment",
        "owasp": "OWASP",
        "cryptography": "Cryptography",
        "firewall": "Firewalls",
        "firewalls": "Firewalls",
        "wireshark": "Wireshark",
        "threat analysis": "Threat Analysis",
        "iam": "Identity & Access Management (IAM)",
        "identity and access management": "Identity & Access Management (IAM)",
        "secure code review": "Secure Code Review",
        "soc": "SOC Operations",
        "soc operations": "SOC Operations",

        # Finance & Accounting
        "valuation": "Valuation",
        "accounting": "Accounting",
        "budgeting": "Budgeting",
        "financial reporting": "Financial Reporting",
        "auditing": "Auditing",
        "audit": "Auditing",
        "tax compliance": "Tax Compliance",
        "general ledger": "General Ledger",
        "gl": "General Ledger",
        "portfolio management": "Portfolio Management",
        "corporate finance": "Corporate Finance",

        # Product Design / UI/UX
        "figma": "Figma",
        "ui/ux": "UI/UX Design",
        "ui/ux design": "UI/UX Design",
        "ux design": "UI/UX Design",
        "ui design": "UI/UX Design",
        "wireframing": "Wireframing",
        "wireframes": "Wireframing",
        "prototyping": "Prototyping",
        "prototype": "Prototyping",
        "user research": "User Research",
        "usability testing": "Usability Testing",
        "design systems": "Design Systems",
        "design system": "Design Systems",
        "information architecture": "Information Architecture",
        "user flows": "User Flows",
        "interaction design": "Interaction Design",

        # Mechanical Engineering & Robotics
        "solidworks": "SolidWorks",
        "cad": "CAD",
        "fea": "Finite Element Analysis (FEA)",
        "finite element analysis": "Finite Element Analysis (FEA)",
        "thermodynamics": "Thermodynamics",
        "gd&t": "GD&T",
        "gdt": "GD&T",
        "robotics": "Robotics",
        "plc": "PLC Programming",
        "plc programming": "PLC Programming",
        "control systems": "Control Systems",
        "embedded c": "Embedded C",
        "ros": "ROS",
        "cnc": "CNC Machining",
        "cnc machining": "CNC Machining",
    }

    @classmethod
    def get_all_canonical_skills(cls) -> Set[str]:
        """Returns flattened set of all canonical skills in taxonomy."""
        all_skills = set()
        for category_skills in cls.SKILL_TAXONOMY.values():
            all_skills.update(category_skills)
        return all_skills

    @classmethod
    def extract_skills_with_evidence(cls, text: str) -> Dict[str, str]:
        """
        Extracts recognized skills along with a clean context evidence snippet
        from the text. Returns Dict[canonical_skill_name, evidence_snippet].
        """
        if not text:
            return {}

        results: Dict[str, str] = {}
        sentences = cls._split_into_sentences(text)

        # Build search patterns for all canonical and alias forms
        candidates_to_canonical: Dict[str, str] = {}

        # 1. Canonical taxonomy
        for cat_skills in cls.SKILL_TAXONOMY.values():
            for skill in cat_skills:
                candidates_to_canonical[skill.lower()] = skill

        # 2. Aliases in normalization map
        for alias, canonical in cls.NORMALIZATION_MAP.items():
            candidates_to_canonical[alias.lower()] = canonical

        # Match against text using word-boundary regular expressions
        # Sort keys by length descending to match longest phrases first (e.g., 'REST APIs' before 'REST')
        sorted_keys = sorted(candidates_to_canonical.keys(), key=len, reverse=True)

        for key in sorted_keys:
            canonical = candidates_to_canonical[key]
            # Handle special symbols like C++, C#, .NET
            escaped_key = re.escape(key)

            # Strict boundaries: ensure we don't partially match 'C' inside 'Cat' or 'HTML'
            if key in ["c", "r"]:
                # Require explicit punctuation or standalone space
                pattern = rf"(?:^|[\s,;:(])({escaped_key})(?:[\s,;:.)]|$)"
            else:
                pattern = rf"\b{escaped_key}\b"

            regex = re.compile(pattern, re.IGNORECASE)

            # Find matching sentence
            for sentence in sentences:
                if regex.search(sentence):
                    if canonical not in results:
                        # Clean sentence for display as evidence snippet
                        clean_sentence = re.sub(r"\s+", " ", sentence).strip()
                        if len(clean_sentence) > 140:
                            clean_sentence = clean_sentence[:137] + "..."
                        results[canonical] = clean_sentence
                    break

        return results

    @classmethod
    def extract_required_skills(cls, job_description: str) -> List[str]:
        """
        Extracts required skills from the job description.
        Returns deduplicated canonical skill names.
        """
        extracted = cls.extract_skills_with_evidence(job_description)
        return sorted(list(extracted.keys()))

    @classmethod
    def _split_into_sentences(cls, text: str) -> List[str]:
        """Splits multi-paragraph text into clean candidate sentences and bullet points."""
        # Split on newlines, bullet points, periods, or semicolons
        raw_chunks = re.split(r"[\n•\r\t]+|(?<=[.!?])\s+", text)
        sentences = [c.strip() for c in raw_chunks if len(c.strip()) > 3]
        return sentences
