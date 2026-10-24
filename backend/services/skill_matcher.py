import logging
import os
import threading
from typing import Dict, List, Optional, Tuple
import numpy as np

from models.schemas import (
    AnalyzeResumeResponse,
    SkillMatchItem,
    SkillRecommendationItem,
    SkillStatus,
)
from services.semantic_engine import SemanticSimilarityEngine
from services.skill_extractor import SkillExtractor

logger = logging.getLogger(__name__)

# Actionable domain-specific advice map for identified gaps
RECOMMENDATION_TEMPLATES: Dict[str, str] = {
    # Tech & Software Development
    "React": "Review React core fundamentals including hooks (useState, useEffect), component lifecycles, state management (Redux/Context), and build a small CRUD project.",
    "Node.js": "Practice building asynchronous RESTful APIs using Express or NestJS, handling middleware, request validation, and database connectors.",
    "Python": "Strengthen practical Python skills with object-oriented paradigms, standard libraries, virtual environments, and API development with FastAPI/Flask.",
    "Java": "Focus on Java OOP principles, Collections framework, exception handling, and building backend services with Spring Boot.",
    "JavaScript": "Master modern ES6+ features (async/await, destructuring, promises, closures) and event-driven DOM manipulation.",
    "TypeScript": "Practice strict type definitions, interfaces, generics, and integrating TypeScript into React or Node.js codebases.",
    "REST APIs": "Study HTTP status codes, verbs (GET, POST, PUT, DELETE), request/response headers, and API documentation with OpenAPI/Swagger.",
    "Docker": "Learn container basics: writing Dockerfiles, creating lightweight multi-stage builds, container networking, and docker-compose orchestration.",
    "Git": "Review branching workflows (GitFlow, feature branches), rebasing, resolving merge conflicts, and contributing through pull requests on GitHub.",
    "SQL": "Practice complex SQL queries including multi-table joins, subqueries, indexing, transactions, and schema normalization.",
    "PostgreSQL": "Explore PostgreSQL advanced features such as JSONB indexing, window functions, and connection pooling.",
    "MongoDB": "Practice NoSQL document modeling, indexing, aggregation pipelines, and connecting to applications via Mongoose or PyMongo.",
    "Machine Learning": "Review supervised learning algorithms (regression, decision trees, ensemble methods), evaluation metrics (precision, recall, ROC-AUC), and scikit-learn.",
    "Deep Learning": "Study neural network architectures (CNNs, RNNs/Transformers), optimization techniques (Adam, dropout), and build models with PyTorch or TensorFlow.",
    "Data Analysis": "Practice data cleaning, exploratory data analysis (EDA), feature engineering with Pandas, and data visualization with Seaborn or Matplotlib.",
    "AWS": "Familiarize yourself with AWS core cloud services: EC2, S3, Lambda, IAM permissions, and deploying containerized applications.",
    "Kubernetes": "Understand pod lifecycle, deployments, services, ingress controllers, and config maps for container orchestration.",
    "Flutter": "Deepen knowledge of Flutter state management (Provider/Riverpod), responsive widget layouts, animations, and asynchronous platform channels.",
    "Data Structures": "Practice algorithmic problem solving covering trees, graphs, heaps, dynamic programming, and time/space complexity analysis.",
    "Software Testing": "Learn to write automated unit, integration, and mocking tests using frameworks like PyTest, Jest, or JUnit.",

    # Civil Engineering
    "AutoCAD": "Master 2D drafting, layer management, dimensioning standards, and 3D wireframe modeling according to municipal building codes. Complete practical site layout projects.",
    "STAAD.Pro": "Practice finite element analysis (FEA), concrete and steel frame modeling, load combinations (dead, live, seismic, wind), and automated design code verification.",
    "Revit": "Study Building Information Modeling (BIM) workflows, parametric family creation, structural reinforcement detailing, and multidisciplinary clash detection.",
    "Structural Analysis": "Strengthen core understanding of bending moments, shear forces, indeterminate frame analysis, load path distribution, and design code compliance (IS 456 / ACI 318).",
    "Site Safety": "Complete OSHA or NEBOSH safety compliance certification. Review PPE enforcement, job hazard analysis (JHA), scaffolding safety, and site emergency protocols.",
    "Geotechnical Engineering": "Review soil mechanics, triaxial shear testing, Terzaghi's bearing capacity calculations, soil classification, and slope stability analysis.",
    "Estimation & Costing": "Practice detailed quantity takeoff from structural blueprints, rate analysis, preparing bill of quantities (BOQ), and CPWD/standard specification compliance.",
    "Surveying": "Gain hands-on proficiency with Total Station operation, contour mapping, differential leveling, traverse adjustment, and GPS coordinates calculation.",
    "Primavera P6": "Master critical path method (CPM) scheduling, resource allocation and leveling, baseline variance tracking, and earned value management (EVM).",
    "Building Information Modeling (BIM)": "Understand Level of Development (LOD 100-500) specifications, 4D construction sequencing, and Navisworks collaborative coordination.",

    # Animation & Digital Media
    "Blender": "Master Blender geometry nodes, hard-surface modeling, procedural shading in Cycles/Eevee, and complete a production-ready character asset portfolio piece.",
    "Maya": "Practice industry-standard polygonal modeling, clean edge flow, UV unfolding, blendshape sculpting, and animation curve graph editor workflows.",
    "Rigging": "Build robust bipedal and quadruped skeletons featuring IK/FK switching, stretchy spine setups, deformers, weight painting, and intuitive animator control curves.",
    "Keyframing": "Deepen mastery of the 12 Principles of Animation: timing and spacing, squash and stretch, anticipation, follow-through, arcs, and secondary action.",
    "Motion Graphics": "Learn kinetic typography, shape layer morphing, track mattes, particle systems, and vector animations in Adobe After Effects.",
    "Storyboarding": "Practice visual continuity, cinematic camera angles, composition rule of thirds, perspective drawing, and generating timed animatics.",
    "Character Animation": "Animate convincing walk/run cycles, personality-driven acting shots, physical weight shifts, and accurate facial lip-sync with live reference footage.",
    "After Effects": "Master planar tracking with Mocha, green-screen keying, rotoscoping, expression scripting, and multi-pass 3D render compositing.",
    "Cinema 4D": "Explore MoGraph procedural cloners, dynamics simulations, Redshift/Octane GPU shaders, and broadcast title design.",
    "ZBrush": "Practice digital sculpting with DynaMesh, ZRemesher topology cleanup, micro-detail alpha stamping, and high-frequency anatomical sculpting.",
    "VFX": "Study live-action plate matchmoving, CG object integration, dynamic fluid and smoke simulations, and node-based compositing.",

    # Healthcare & Nursing
    "Patient Triage": "Review Emergency Severity Index (ESI) triage criteria, rapid ABC (Airway, Breathing, Circulation) assessment protocols, and prioritizing acute clinical care.",
    "EHR/EMR Charting": "Familiarize yourself with hospital information systems (Epic, Cerner), accurate SOAP note documentation, and barcode medication scanning protocols.",
    "BLS Certification": "Acquire or renew AHA-accredited Basic Life Support (BLS) certification covering high-quality CPR, bag-valve mask ventilation, and AED operation.",
    "ACLS Certification": "Complete Advanced Cardiovascular Life Support (ACLS) certification focusing on ECG rhythm recognition, acute coronary syndromes, and resuscitation algorithms.",
    "Pharmacology": "Review high-alert medications, parenteral dosage calculations, therapeutic drug monitoring, adverse side effects, and pharmacokinetic principles.",
    "HIPAA Compliance": "Complete HIPAA compliance training covering patient health information (PHI) confidentiality, electronic record privacy, and security protocols.",
    "Vital Signs Monitoring": "Ensure proficiency in manual blood pressure auscultation, telemetry lead placement, pulse oximetry, and recognizing early warning scores (NEWS/MEWS).",
    "Infection Control": "Review CDC standard and transmission-based precautions, sterile technique during invasive procedures, hand hygiene compliance, and PPE donning/doffing.",
    "IV Cannulation": "Practice peripheral intravenous (PIV) catheter insertion, selecting appropriate vein sites, aseptic venipuncture, and calculating infusion drip rates.",
    "Wound Care": "Study staging and assessment of pressure ulcers, aseptic dressing techniques, wound bed preparation, and negative pressure wound therapy (NPWT).",
    "Medication Administration": "Strictly follow the 6 Rights of Medication Administration, independent double-checking for insulin and heparin, and oral/subcutaneous/IM delivery techniques.",

    # Cybersecurity
    "Network Security": "Study OSI layer defense mechanisms, stateful packet inspection, network segmentation, zero-trust architectures, and VPN tunneling protocols.",
    "Penetration Testing": "Practice CTF challenges on HackTheBox/TryHackMe. Master penetration testing methodologies (PTES) using tools like Nmap, Metasploit, and Burp Suite.",
    "SIEM": "Gain hands-on proficiency configuring log aggregation, alert correlation rules, and incident detection dashboards in Splunk or Elastic SIEM.",
    "Incident Response": "Learn the NIST incident handling lifecycle: preparation, detection & analysis, containment, eradication, recovery, and post-incident review.",
    "Vulnerability Assessment": "Practice vulnerability scanning using Nessus, Qualys, or OpenVAS, CVE severity scoring (CVSS v3), and generating remediation plans.",
    "OWASP": "Master the OWASP Top 10 vulnerabilities (SQLi, XSS, SSRF, Broken Auth) and secure code mitigation techniques.",
    "Cryptography": "Review public-key infrastructure (PKI), TLS/SSL handshakes, symmetric/asymmetric cipher algorithms (AES, RSA, ECC), and cryptographic hash functions.",
    "Firewalls": "Practice configuring next-generation firewall (NGFW) access control lists (ACLs), NAT policies, and IDS/IPS inspection signatures.",
    "Wireshark": "Deepen packet analysis skills: filtering TCP handshakes, identifying unencrypted payloads, analyzing DNS anomalies, and reassembling TCP streams.",
    "Identity & Access Management (IAM)": "Study RBAC/ABAC models, SAML/OIDC federated single sign-on (SSO), multi-factor authentication (MFA), and privilege lifecycle management.",

    # Business & Product Management
    "Financial Modeling": "Build dynamic 3-statement financial models, discounted cash flow (DCF) models, scenario analyses, and sensitivity tables in Excel.",
    "Project Management": "Study PMP/Agile frameworks, Work Breakdown Structures (WBS), risk registers, stakeholder communications, and resource leveling.",
    "Risk Management": "Learn qualitative and quantitative risk assessment, risk mitigation strategies, FMEA frameworks, and business continuity planning.",
    "Business Analysis": "Practice eliciting business requirements, modeling workflows with BPMN, conducting GAP analyses, and writing detailed PRDs/user stories.",
    "Microsoft Excel": "Master advanced Excel functions (INDEX/MATCH, XLOOKUP, dynamic arrays, nested logic), Pivot Tables, and automated macros.",

    # Finance & Accounting
    "Valuation": "Review valuation methodologies including comparable company analysis (Trading Comps), precedent transactions, and DCF enterprise valuation.",
    "Accounting": "Strengthen understanding of GAAP/IFRS principles, accrual accounting, balance sheet reconciliations, and journal entry auditing.",
    "Budgeting": "Practice zero-based and incremental budgeting, department variance forecasting, and operating expenditure (OpEx/CapEx) tracking.",
    "Financial Reporting": "Learn to prepare and audit quarterly 10-Q/10-K financial disclosures, cash flow statements, and executive board decks.",
    "Auditing": "Review internal control evaluation frameworks (COSO), substantive testing procedures, audit trail documentation, and compliance testing.",
    "Tax Compliance": "Study corporate tax schedules, withholding calculations, depreciation recapture (MACRS), and regulatory filing compliance.",
    "General Ledger": "Master double-entry accounting, month-end trial balance reconciliation, sub-ledger posting, and intercompany eliminations.",

    # Product Design & UI/UX
    "Figma": "Master Figma auto-layout, component variants, interactive prototyping with smart animations, and tokenized design systems.",
    "UI/UX Design": "Study human-centered design principles, visual hierarchy, typography, color theory, accessibility (WCAG AA), and micro-interactions.",
    "Wireframing": "Practice low-fidelity wireframing and sketching to rapidly explore layout alternatives and validate user journeys before visual design.",
    "Prototyping": "Create high-fidelity interactive prototypes simulating micro-interactions, complex user paths, and dynamic state transitions.",
    "User Research": "Conduct structured user interviews, contextual inquiries, card sorting exercises, and synthesize affinity diagrams into actionable personas.",
    "Usability Testing": "Plan and moderate usability testing sessions, define task success metrics (SUS/CES), and identify behavioral friction points.",
    "Design Systems": "Learn atomic design methodology, design token architecture, and cross-platform component library governance.",
    "Information Architecture": "Practice sitemap generation, content auditing, taxonomy structuring, and user flow mapping.",

    # Mechanical Engineering & Robotics
    "SolidWorks": "Master 3D parametric part and assembly modeling, sheet metal design, surface modeling, and generating ASME Y14.5 drafting drawings.",
    "CAD": "Develop proficiency in computer-aided design, parametric constraints, assembly mating, and drawing detailing standards.",
    "Finite Element Analysis (FEA)": "Practice static structural, thermal, and modal simulations using ANSYS or SolidWorks Simulation; understand mesh refinement and stress singularities.",
    "Thermodynamics": "Review heat transfer modes (conduction, convection, radiation), thermodynamic cycles (Rankine, Brayton, Carnot), and HVAC energy balance.",
    "GD&T": "Master Geometric Dimensioning and Tolerancing (GD&T) datums, position tolerance, runout, profile, and MMC/LMC modifier applications.",
    "Robotics": "Study forward/inverse kinematics, path planning algorithms, sensor fusion (IMU, LiDAR), and motor control systems.",
    "PLC Programming": "Learn ladder logic, functional block diagrams, structured text programming (IEC 61131-3), and industrial sensor/actuator interfacing.",
    "Control Systems": "Review PID loop tuning, feedback control architectures, Laplace transforms, Bode plots, and stability margins.",
    "Embedded C": "Practice embedded microcontroller programming, bare-metal peripheral drivers (GPIO, I2C, SPI, UART), and real-time operating systems (FreeRTOS).",
    "ROS": "Master Robot Operating System (ROS/ROS2) node architectures, publishers, subscribers, custom service messages, and URDF robot modeling.",
}


class SkillMatcher:
    """
    Performs semantic skill matching and gap calculation using
    SentenceTransformers and transparent formula calculations.
    """

    _model = None
    _model_initialized = False
    _model_lock = threading.Lock()

    @classmethod
    def get_model(cls):
        """
        Loads SentenceTransformer ONLY if ENABLE_TRANSFORMERS is explicitly set to true.
        By default on cloud environments (e.g. Render 512MB free tier), heavy PyTorch
        models are disabled to eliminate Out-Of-Memory (OOM) SIGKILL crashes (502 Bad Gateway).
        SemanticSimilarityEngine provides instant, highly accurate semantic matching in <1ms with 0MB RAM.
        """
        enable_transformers = os.getenv("ENABLE_TRANSFORMERS", "false").strip().lower() in ("true", "1", "yes")
        if not enable_transformers:
            return False

        if cls._model_initialized:
            return cls._model

        with cls._model_lock:
            if cls._model_initialized:
                return cls._model

            model_name = os.getenv("SENTENCE_TRANSFORMER_MODEL", "all-MiniLM-L6-v2")
            try:
                from sentence_transformers import SentenceTransformer
                logger.info(f"Loading SentenceTransformer model '{model_name}'...")
                cls._model = SentenceTransformer(model_name)
                logger.info(f"SentenceTransformer model '{model_name}' initialized successfully.")
            except Exception as e:
                logger.warning(
                    f"SentenceTransformer could not be loaded ({e}). "
                    "Using high-performance SemanticSimilarityEngine."
                )
                cls._model = False
            finally:
                cls._model_initialized = True

        return cls._model

    @classmethod
    def cosine_similarity(cls, vec1: np.ndarray, vec2: np.ndarray) -> float:
        """Calculates cosine similarity between two 1D vectors."""
        dot = np.dot(vec1, vec2)
        norm1 = np.linalg.norm(vec1)
        norm2 = np.linalg.norm(vec2)
        if norm1 == 0 or norm2 == 0:
            return 0.0
        return float(dot / (norm1 * norm2))

    @classmethod
    def analyze(
        cls,
        resume_text: str,
        job_description: str,
        job_title: str,
        company_name: Optional[str] = None,
    ) -> AnalyzeResumeResponse:
        """
        Executes complete skill extraction, semantic matching, and gap report generation.
        """
        # 1. Extract skills from resume
        resume_skills_map = SkillExtractor.extract_skills_with_evidence(resume_text)

        # 2. Extract required skills from job description
        required_skills = SkillExtractor.extract_required_skills(job_description)

        # Fallback if JD didn't yield taxonomy skills: try extracting general tech keywords from job title
        if not required_skills:
            title_skills = SkillExtractor.extract_required_skills(job_title)
            if title_skills:
                required_skills = title_skills

        if not required_skills:
            raise ValueError(
                "We couldn't identify specific technical requirements from the provided job description. "
                "Please enter a more detailed job description outlining required technical skills and qualifications."
            )

        matched_items: List[SkillMatchItem] = []
        partial_items: List[SkillMatchItem] = []
        gap_items: List[SkillMatchItem] = []

        candidate_skills = list(resume_skills_map.keys())
        model = cls.get_model()

        # Optional SentenceTransformer embeddings if explicitly enabled
        candidate_embeddings = {}
        if model and candidate_skills:
            try:
                embeddings = model.encode(candidate_skills)
                for s, emb in zip(candidate_skills, embeddings):
                    candidate_embeddings[s] = emb
            except Exception as e:
                logger.error(f"Error encoding candidate skills: {e}")

        for req_skill in required_skills:
            # 1. Direct canonical match in resume
            if req_skill in resume_skills_map:
                evidence = resume_skills_map[req_skill]
                matched_items.append(
                    SkillMatchItem(
                        name=req_skill,
                        status=SkillStatus.MATCHED,
                        resume_evidence=evidence if evidence else f"Mentioned in resume under skills or projects.",
                    )
                )
                continue

            # 2. Semantic matching using SemanticSimilarityEngine
            best_candidate, best_sim = SemanticSimilarityEngine.find_best_semantic_match(
                req_skill, candidate_skills
            )

            # Compare with SentenceTransformer if available
            if model and candidate_embeddings:
                try:
                    req_emb = model.encode([req_skill])[0]
                    for cand_skill, cand_emb in candidate_embeddings.items():
                        sim = cls.cosine_similarity(req_emb, cand_emb)
                        if sim > best_sim:
                            best_sim = sim
                            best_candidate = cand_skill
                except Exception as e:
                    logger.debug(f"Transformer comparison error: {e}")

            # High semantic similarity threshold (>= 0.75)
            if best_sim >= 0.75 and best_candidate:
                evidence = resume_skills_map.get(best_candidate, "")
                matched_items.append(
                    SkillMatchItem(
                        name=req_skill,
                        status=SkillStatus.MATCHED,
                        resume_evidence=f"Strongly aligned with candidate competence in {best_candidate}: \"{evidence}\"",
                    )
                )
            # Moderate similarity threshold (0.55 - 0.75): Needs verification
            elif best_sim >= 0.55 and best_candidate:
                evidence = resume_skills_map.get(best_candidate, "")
                partial_items.append(
                    SkillMatchItem(
                        name=req_skill,
                        status=SkillStatus.PARTIAL,
                        reason=f"Related competency identified in {best_candidate}, but specific experience with {req_skill} needs verification.",
                        resume_evidence=evidence,
                    )
                )
            else:
                gap_items.append(
                    SkillMatchItem(
                        name=req_skill,
                        status=SkillStatus.POTENTIAL_GAP,
                        reason="The skill was required in the job description but was not identified in the resume.",
                    )
                )

        # Calculate transparent match score
        total_reqs = len(required_skills)
        matched_count = len(matched_items)
        partial_count = len(partial_items)

        if total_reqs > 0:
            raw_score = ((matched_count + (0.5 * partial_count)) / total_reqs) * 100
            match_score = int(round(raw_score))
            match_score = max(0, min(100, match_score))
        else:
            match_score = 0

        # Generate targeted recommendations for gaps and partials
        recommendations: List[SkillRecommendationItem] = []
        for gap in gap_items:
            rec_text = RECOMMENDATION_TEMPLATES.get(
                gap.name,
                f"Review fundamental concepts and documentation for {gap.name}. If you have practical project experience with {gap.name}, update your resume to clearly showcase relevant contributions."
            )
            recommendations.append(
                SkillRecommendationItem(skill=gap.name, recommendation=rec_text)
            )

        for partial in partial_items:
            rec_text = (
                f"Your experience with related tools is promising. Add specific project achievements or repository links demonstrating concrete proficiency in {partial.name}."
            )
            recommendations.append(
                SkillRecommendationItem(skill=partial.name, recommendation=rec_text)
            )

        # Summary statement
        if match_score >= 75:
            summary = (
                f"Strong skill alignment for {job_title}. Your resume directly matches {matched_count} of the {total_reqs} "
                "key technical requirements. Review the recommendations to address the remaining potential gaps before applying."
            )
        elif match_score >= 50:
            summary = (
                f"Moderate skill alignment for {job_title}. Your resume matches {matched_count} requirements with {partial_count} partial "
                f"competencies. Highlighting your experience in the {len(gap_items)} identified gap areas will strengthen your candidacy."
            )
        else:
            summary = (
                f"Foundational alignment for {job_title}. Your resume demonstrates {matched_count} matched competencies. "
                "Consider completing targeted projects or certifications in the identified gap areas to meet the role's core expectations."
            )

        return AnalyzeResumeResponse(
            job_title=job_title,
            match_score=match_score,
            matched_skills=matched_items,
            partial_skills=partial_items,
            potential_missing_skills=gap_items,
            recommendations=recommendations,
            summary=summary,
        )
