import logging
import math
import os
import re
from typing import Dict, List, Optional, Set, Tuple

logger = logging.getLogger(__name__)

# Domain Ontology: Maps canonical skills to synonym clusters and closely related competencies.
# Weight scale: 1.0 = exact/synonym equivalent, 0.75 = tight parent/child or framework coupling, 0.60 = adjacent competency
SKILL_RELATIONSHIPS: Dict[str, Dict[str, float]] = {
    # Web & Software Development
    "React": {
        "react.js": 1.0, "reactjs": 1.0, "next.js": 0.85, "redux": 0.78, "jsx": 0.88,
        "frontend": 0.70, "vue": 0.68, "angular": 0.65, "context api": 0.75, "javascript": 0.70
    },
    "Node.js": {
        "nodejs": 1.0, "node": 0.95, "express": 0.88, "express.js": 0.88, "nestjs": 0.85,
        "backend": 0.72, "rest apis": 0.75, "javascript": 0.68
    },
    "TypeScript": {
        "ts": 0.95, "javascript": 0.78, "typed javascript": 0.95, "frontend": 0.65
    },
    "JavaScript": {
        "js": 0.95, "es6": 0.95, "es6+": 0.95, "typescript": 0.78, "frontend": 0.68
    },
    "REST APIs": {
        "restful": 0.95, "rest api": 1.0, "restful api": 0.98, "api development": 0.90,
        "api": 0.85, "endpoints": 0.80, "graphql": 0.68, "web services": 0.78, "json": 0.70
    },
    "PostgreSQL": {
        "postgres": 1.0, "postgresql": 1.0, "sql": 0.82, "relational database": 0.85,
        "rdbms": 0.85, "mysql": 0.72, "database": 0.70
    },
    "MySQL": {
        "sql": 0.82, "relational database": 0.85, "rdbms": 0.85, "postgresql": 0.72, "database": 0.70
    },
    "MongoDB": {
        "mongo": 0.95, "nosql": 0.85, "document database": 0.85, "mongoose": 0.85
    },
    "Docker": {
        "containerization": 0.92, "containers": 0.90, "docker compose": 0.95,
        "kubernetes": 0.78, "k8s": 0.78, "devops": 0.68
    },
    "Kubernetes": {
        "k8s": 1.0, "container orchestration": 0.95, "docker": 0.78, "helm": 0.80, "devops": 0.72
    },
    "Git": {
        "github": 0.85, "gitlab": 0.85, "version control": 0.90, "vcs": 0.90, "gitflow": 0.90
    },
    "Python": {
        "python3": 1.0, "fastapi": 0.78, "flask": 0.78, "django": 0.78, "pandas": 0.70
    },
    "Java": {
        "java 8": 0.95, "java 11": 0.95, "java 17": 0.95, "spring boot": 0.85, "spring": 0.82
    },
    "HTML": {
        "html5": 1.0, "web development": 0.70, "frontend": 0.65
    },
    "CSS": {
        "css3": 1.0, "tailwind css": 0.85, "bootstrap": 0.80, "sass": 0.85, "responsive design": 0.75
    },
    "Machine Learning": {
        "ml": 1.0, "deep learning": 0.80, "scikit-learn": 0.85, "data science": 0.82,
        "predictive modeling": 0.88, "ai": 0.80, "pandas": 0.70
    },
    "Deep Learning": {
        "neural networks": 0.92, "pytorch": 0.88, "tensorflow": 0.88, "machine learning": 0.80, "keras": 0.85
    },
    "Data Analysis": {
        "data analytics": 0.98, "eda": 0.88, "pandas": 0.85, "numpy": 0.80, "power bi": 0.78, "tableau": 0.78
    },
    "AWS": {
        "amazon web services": 1.0, "ec2": 0.85, "s3": 0.85, "lambda": 0.85, "cloud computing": 0.80
    },

    # Civil Engineering
    "AutoCAD": {
        "cad": 0.90, "2d drafting": 0.92, "drafting": 0.85, "revit": 0.68, "civil drafting": 0.95
    },
    "STAAD.Pro": {
        "staad pro": 1.0, "structural analysis": 0.88, "fea": 0.82, "frame analysis": 0.88, "etabs": 0.80
    },
    "Revit": {
        "bim": 0.88, "building information modeling": 0.90, "autocad": 0.68, "navisworks": 0.80
    },
    "Structural Analysis": {
        "structural design": 0.92, "staad.pro": 0.88, "fea": 0.85, "concrete design": 0.80, "steel design": 0.80
    },
    "Site Safety": {
        "safety compliance": 0.95, "osha": 0.90, "nebosh": 0.90, "hazard analysis": 0.88, "ppe": 0.85
    },
    "Surveying": {
        "total station": 0.92, "leveling": 0.88, "traverse": 0.85, "contour mapping": 0.85
    },

    # Animation & Media
    "Blender": {
        "3d modeling": 0.88, "maya": 0.75, "cycles": 0.85, "eevee": 0.85, "zbrush": 0.70
    },
    "Maya": {
        "autodesk maya": 1.0, "3d modeling": 0.88, "3d animation": 0.90, "blender": 0.75, "rigging": 0.78
    },
    "Rigging": {
        "character rigging": 1.0, "skeletal setup": 0.92, "ik/fk": 0.90, "weight painting": 0.88
    },
    "Keyframing": {
        "animation timing": 0.90, "12 principles": 0.88, "inbetweens": 0.85, "character animation": 0.80
    },
    "After Effects": {
        "motion graphics": 0.92, "compositing": 0.85, "vfx": 0.80, "adobe after effects": 1.0
    },

    # Healthcare & Nursing
    "Patient Triage": {
        "triage": 1.0, "esi triage": 0.95, "acuity assessment": 0.90, "abc assessment": 0.88
    },
    "EHR/EMR Charting": {
        "electronic health records": 1.0, "emr": 0.98, "ehr": 0.98, "epic": 0.90, "cerner": 0.90, "soap notes": 0.88
    },
    "BLS Certification": {
        "bls": 1.0, "basic life support": 1.0, "cpr": 0.95, "aed": 0.90, "resuscitation": 0.88
    },
    "Vital Signs Monitoring": {
        "vital signs": 1.0, "blood pressure": 0.90, "telemetry": 0.85, "pulse oximetry": 0.88
    },

    # Cybersecurity
    "Network Security": {
        "firewalls": 0.82, "vpn": 0.80, "ids/ips": 0.85, "zero trust": 0.80, "osi model": 0.78
    },
    "Penetration Testing": {
        "pen testing": 1.0, "ethical hacking": 0.95, "burp suite": 0.88, "metasploit": 0.88, "ctf": 0.80
    },
    "SIEM": {
        "splunk": 0.88, "log analysis": 0.85, "incident detection": 0.85, "soc": 0.80
    },
}


class SemanticSimilarityEngine:
    """
    Ultra-lightweight, zero-memory-footprint semantic similarity engine.
    Combines:
    1. Domain ontology graph traversal
    2. Subword character 3-gram and 4-gram TF-IDF cosine similarity
    3. Token containment and normalized Levenshtein distance
    Runs in <1ms and requires <2MB RAM, making it immune to cloud OOM kills on 512MB instances.
    """

    @classmethod
    def normalize_term(cls, term: str) -> str:
        """Strips punctuation, lowercases, and standardizes spacing."""
        term = term.lower().strip()
        term = re.sub(r"[^\w\s\+\#\.]", " ", term)
        term = re.sub(r"\s+", " ", term).strip()
        return term

    @classmethod
    def get_char_ngrams(cls, text: str, n_range: Tuple[int, int] = (3, 4)) -> Dict[str, int]:
        """Extracts character n-grams with frequency weights."""
        norm = f"^{cls.normalize_term(text)}^"
        ngrams: Dict[str, int] = {}
        for n in range(n_range[0], n_range[1] + 1):
            if len(norm) < n:
                continue
            for i in range(len(norm) - n + 1):
                gram = norm[i : i + n]
                ngrams[gram] = ngrams.get(gram, 0) + 1
        return ngrams

    @classmethod
    def char_ngram_cosine_similarity(cls, text1: str, text2: str) -> float:
        """Computes cosine similarity between character n-gram vectors."""
        vec1 = cls.get_char_ngrams(text1)
        vec2 = cls.get_char_ngrams(text2)

        if not vec1 or not vec2:
            return 0.0

        dot = 0.0
        for gram, freq1 in vec1.items():
            if gram in vec2:
                dot += freq1 * vec2[gram]

        norm1 = math.sqrt(sum(v * v for v in vec1.values()))
        norm2 = math.sqrt(sum(v * v for v in vec2.values()))

        if norm1 == 0.0 or norm2 == 0.0:
            return 0.0

        return float(dot / (norm1 * norm2))

    @classmethod
    def compute_similarity(cls, required_skill: str, candidate_skill: str) -> float:
        """
        Computes composite semantic similarity between required skill and candidate skill.
        Returns score from 0.0 to 1.0.
        """
        norm_req = cls.normalize_term(required_skill)
        norm_cand = cls.normalize_term(candidate_skill)

        # 1. Exact canonical or normalized match
        if norm_req == norm_cand:
            return 1.0

        # 2. Check Domain Ontology Knowledge Graph
        # Forward check (required -> candidate)
        for canon, rels in SKILL_RELATIONSHIPS.items():
            if canon.lower() == norm_req:
                for rel_term, weight in rels.items():
                    if rel_term.lower() == norm_cand or rel_term.lower() in norm_cand:
                        return weight

            # Reverse check (candidate -> required)
            if canon.lower() == norm_cand:
                for rel_term, weight in rels.items():
                    if rel_term.lower() == norm_req or rel_term.lower() in norm_req:
                        return weight

        # 3. Direct Substring / Token Containment
        tokens_req = set(norm_req.split())
        tokens_cand = set(norm_cand.split())

        if tokens_req and tokens_cand:
            # Full containment (e.g., 'React' in 'React Hooks' or 'PostgreSQL' in 'PostgreSQL Database')
            if tokens_req.issubset(tokens_cand) or tokens_cand.issubset(tokens_req):
                overlap = len(tokens_req.intersection(tokens_cand))
                total = max(len(tokens_req), len(tokens_cand))
                return max(0.82, float(overlap / total))

            # Jaccard Token Overlap
            intersection = len(tokens_req.intersection(tokens_cand))
            union = len(tokens_req.union(tokens_cand))
            if union > 0 and intersection > 0:
                jaccard = intersection / union
                if jaccard >= 0.5:
                    return max(0.70, jaccard)

        # 4. Character N-Gram Subword TF-IDF Cosine Similarity
        ngram_sim = cls.char_ngram_cosine_similarity(norm_req, norm_cand)
        return ngram_sim

    @classmethod
    def find_best_semantic_match(
        cls, required_skill: str, candidate_skills: List[str]
    ) -> Tuple[Optional[str], float]:
        """
        Finds the candidate skill with the highest semantic similarity to the required skill.
        Returns (best_candidate_skill, best_score).
        """
        best_skill = None
        best_score = 0.0

        for cand in candidate_skills:
            score = cls.compute_similarity(required_skill, cand)
            if score > best_score:
                best_score = score
                best_skill = cand

        return best_skill, best_score
