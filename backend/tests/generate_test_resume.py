"""
Utility script to generate realistic test resumes across multiple industry domains and job positions.
Supports 12 distinct job fields with at least 2 distinct positions per field (24 test resumes total).
Generates PDFs formatted for parsing by PyMuPDF and analysis by the CareerPulse backend pipeline.
"""

import json
import os
import sys
from typing import Any, Dict, List
import pymupdf as fitz


RESUME_DATABASE: List[Dict[str, Any]] = [
    # -------------------------------------------------------------
    # FIELD 1: Software & Systems Engineering
    # -------------------------------------------------------------
    {
        "field_id": "software_engineering",
        "field_name": "Software & Systems Engineering",
        "position_id": "backend_systems_engineer",
        "position_title": "Backend Systems Engineer",
        "filename": "01_software_backend_engineer.pdf",
        "candidate": {
            "name": "Ethan Vance",
            "email": "ethan.vance@techmail.io",
            "phone": "(555) 349-1182",
            "location": "Seattle, WA",
            "linkedin": "linkedin.com/in/ethan-vance-backend",
            "github": "github.com/evance-dev",
        },
        "summary": "Backend Systems Engineer with 4+ years of experience designing high-throughput distributed microservices, low-latency REST APIs, and transactional database architectures. Passionate about system design, performance profiling, and resilient asynchronous pipelines.",
        "education": [
            {
                "degree": "B.S. in Computer Science",
                "institution": "University of Washington",
                "year": "2021",
                "details": "Focus on Distributed Systems and Database Internals. Dean's List.",
            }
        ],
        "skills": {
            "Programming": "Python, Java, Go, SQL, Bash",
            "Backend & APIs": "FastAPI, Spring Boot, REST APIs, Microservices, Redis",
            "Databases & Storage": "PostgreSQL, MySQL, MongoDB, Elasticsearch",
            "Infrastructure & Tools": "Docker, Kubernetes, Linux, Git, CI/CD",
            "Engineering Concepts": "Data Structures, Algorithms, System Design, Unit Testing",
        },
        "experience": [
            {
                "role": "Senior Backend Engineer",
                "company": "Apex Cloud Systems",
                "period": "2022 — Present",
                "bullets": [
                    "Architected high-throughput REST APIs handling 40M+ daily requests using FastAPI and Python.",
                    "Designed PostgreSQL partitioning strategy and Redis caching layer, reducing p99 latency by 42%.",
                    "Migrated legacy monolithic services into containerized microservices managed via Docker and Kubernetes.",
                    "Enforced strict unit testing standards with pytest and automated CI/CD pipeline deployment validations.",
                ],
            },
            {
                "role": "Software Engineer",
                "company": "DataStream Solutions",
                "period": "2021 — 2022",
                "bullets": [
                    "Developed backend data ingestion pipelines in Java and Python with MySQL and PostgreSQL connectors.",
                    "Implemented asynchronous job worker queues using Celery and Redis to process batch transaction files.",
                    "Collaborated on core system design documentation and optimized complex SQL analytical queries.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Distributed Key-Value Store",
                "technologies": "Go, Raft Consensus, Docker",
                "bullets": [
                    "Implemented distributed consensus mechanism achieving linearizable reads across 5 node clusters.",
                    "Containerized testing environments with Docker and benchmarked failover recovery times under 200ms.",
                ],
            }
        ],
        "target_job": {
            "title": "Senior Backend Software Engineer",
            "description": "Seeking an experienced Backend Engineer skilled in Python, FastAPI, PostgreSQL, Docker, and REST APIs. Experience with Microservices, Redis, and robust System Design is required. Familiarity with Kubernetes and Git workflows is a plus.",
        },
    },
    {
        "field_id": "software_engineering",
        "field_name": "Software & Systems Engineering",
        "position_id": "fullstack_web_developer",
        "position_title": "Full-Stack Web Developer",
        "filename": "01_software_fullstack_developer.pdf",
        "candidate": {
            "name": "Maya Lin",
            "email": "maya.lin.dev@webcraft.com",
            "phone": "(555) 782-9901",
            "location": "Austin, TX",
            "linkedin": "linkedin.com/in/mayalin-fullstack",
            "github": "github.com/mayalin",
        },
        "summary": "Versatile Full-Stack Developer with 3+ years building modern end-to-end web applications. Skilled in React frontend development, Node.js backend services, GraphQL/REST integrations, and NoSQL/relational databases.",
        "education": [
            {
                "degree": "B.Tech in Information Technology",
                "institution": "Texas A&M University",
                "year": "2022",
                "details": "Specialization in Web & Enterprise Software Systems.",
            }
        ],
        "skills": {
            "Frontend": "React, TypeScript, JavaScript, HTML5, CSS3, Redux, Tailwind CSS",
            "Backend": "Node.js, Express, REST APIs, GraphQL, Next.js",
            "Databases": "MongoDB, PostgreSQL, Firebase",
            "Tools & DevOps": "Git, Docker, Postman, Linux, CI/CD",
            "Methodologies": "Agile Development, Scrum, Unit Testing",
        },
        "experience": [
            {
                "role": "Full-Stack Developer",
                "company": "OmniCommerce Platforms",
                "period": "2022 — Present",
                "bullets": [
                    "Built customer-facing web dashboard using React, TypeScript, and responsive CSS3 styling.",
                    "Engineered secure Node.js and Express REST APIs with JWT authentication and role-based permissions.",
                    "Designed MongoDB document schemas and integrated PostgreSQL for financial transaction history.",
                    "Participated in bi-weekly Agile Development sprints and conducted peer code reviews via Git pull requests.",
                ],
            },
            {
                "role": "Junior Web Developer",
                "company": "Kinetix Digital",
                "period": "2021 — 2022",
                "bullets": [
                    "Maintained interactive client portals built with JavaScript, HTML, CSS, and Express backend.",
                    "Constructed GraphQL endpoints reducing payload size by 35% compared to legacy endpoints.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Collaborative Task Workspace",
                "technologies": "React, Node.js, Express, MongoDB, Docker",
                "bullets": [
                    "Created real-time collaborative kanban board using WebSockets and React frontend.",
                    "Deployed backend services as lightweight Docker containers with automated deployment scripts.",
                ],
            }
        ],
        "target_job": {
            "title": "Full Stack Engineer",
            "description": "We are hiring a Full Stack Developer proficient in React, Node.js, Express, and TypeScript. Must have experience with MongoDB, REST APIs, and Git. Knowledge of GraphQL and Docker containerization is highly valued.",
        },
    },

    # -------------------------------------------------------------
    # FIELD 2: Frontend & Mobile Development
    # -------------------------------------------------------------
    {
        "field_id": "frontend_mobile",
        "field_name": "Frontend & Mobile Development",
        "position_id": "lead_frontend_engineer",
        "position_title": "Lead Frontend Engineer",
        "filename": "02_frontend_web_architect.pdf",
        "candidate": {
            "name": "Julian Alvarez",
            "email": "julian.alvarez@uiworks.io",
            "phone": "(555) 441-2098",
            "location": "San Francisco, CA",
            "linkedin": "linkedin.com/in/julian-alvarez-ui",
            "github": "github.com/jalvarez-ui",
        },
        "summary": "Senior Frontend Engineer with deep expertise in React, Next.js, TypeScript, and high-performance UI architecture. Specializes in design systems, web accessibility (WCAG AA), Core Web Vitals optimization, and state management.",
        "education": [
            {
                "degree": "B.S. in Software Engineering",
                "institution": "San Jose State University",
                "year": "2020",
                "details": "Human-Computer Interaction emphasis.",
            }
        ],
        "skills": {
            "Frontend Core": "React, Next.js, TypeScript, JavaScript, HTML5, CSS3",
            "State & Styling": "Redux, Tailwind CSS, Bootstrap, CSS Modules",
            "Testing & Quality": "Jest, Unit Testing, Software Testing, Cypress",
            "Tooling & Workflow": "Git, Webpack, Vite, REST APIs, Postman",
            "Best Practices": "Agile Development, Responsive Design, WebSockets",
        },
        "experience": [
            {
                "role": "Lead Frontend Engineer",
                "company": "Veloce Web Labs",
                "period": "2022 — Present",
                "bullets": [
                    "Spearheaded redesign of enterprise SaaS portal in Next.js and TypeScript, boosting lighthouse scores to 96+.",
                    "Architected unified UI component library using React, Tailwind CSS, and Storybook across 4 product teams.",
                    "Managed complex client state with Redux Toolkit and integrated real-time WebSockets notifications.",
                    "Established automated unit testing pipelines with Jest achieving 85% component test coverage.",
                ],
            },
            {
                "role": "Frontend Developer",
                "company": "PixelCraft Studios",
                "period": "2020 — 2022",
                "bullets": [
                    "Implemented responsive web interfaces consuming REST APIs using React and modern CSS3.",
                    "Improved client-side rendering speed by 40% through code splitting and asset memoization.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Interactive Analytics Dashboard",
                "technologies": "React, TypeScript, Next.js, Tailwind CSS",
                "bullets": [
                    "Built dynamic data visualization dashboard rendering 10k+ rows with smooth 60fps scrolling.",
                ],
            }
        ],
        "target_job": {
            "title": "Senior Frontend Developer",
            "description": "Looking for a Frontend Specialist skilled in React, TypeScript, Next.js, and Tailwind CSS. The ideal candidate has strong mastery of Redux, REST APIs, HTML5, CSS3, and writing automated Unit Testing suites.",
        },
    },
    {
        "field_id": "frontend_mobile",
        "field_name": "Frontend & Mobile Development",
        "position_id": "mobile_app_developer",
        "position_title": "Mobile Application Developer",
        "filename": "02_frontend_mobile_engineer.pdf",
        "candidate": {
            "name": "Priya Patel",
            "email": "priya.patel@appcraft.dev",
            "phone": "(555) 609-3341",
            "location": "Chicago, IL",
            "linkedin": "linkedin.com/in/priya-patel-mobile",
            "github": "github.com/ppatel-mobile",
        },
        "summary": "Cross-platform Mobile Application Developer with 3+ years experience engineering smooth, accessible iOS and Android apps using Flutter and Dart. Proven record delivering production apps with offline synchronization and responsive Material 3 UI.",
        "education": [
            {
                "degree": "B.S. in Computer Science",
                "institution": "University of Illinois Urbana-Champaign",
                "year": "2022",
                "details": "Specialized in Mobile Computing and Human-Centered Software.",
            }
        ],
        "skills": {
            "Mobile Frameworks": "Flutter, Dart, Android, iOS, React Native",
            "Backend Integration": "Firebase, REST APIs, GraphQL, SQLite",
            "State & Architecture": "Provider, Riverpod, Object-Oriented Programming, BLoC",
            "Engineering Tools": "Git, Postman, CI/CD, Fastlane, Postman",
            "Core Competencies": "Data Structures, Debugging, Software Testing",
        },
        "experience": [
            {
                "role": "Mobile App Developer",
                "company": "SyncPulse Technologies",
                "period": "2022 — Present",
                "bullets": [
                    "Engineered cross-platform mobile application in Flutter and Dart reaching 150k+ active mobile users.",
                    "Integrated Firebase Cloud Firestore, Firebase Authentication, and push notification services.",
                    "Connected mobile clients to backend REST APIs with offline caching using SQLite database.",
                    "Reduced app crash rate to 0.05% through rigorous debugging and unit testing implementation.",
                ],
            },
            {
                "role": "Junior Mobile Developer",
                "company": "AppVentures Media",
                "period": "2021 — 2022",
                "bullets": [
                    "Developed reusable Flutter UI widgets adhering to iOS Cupertino and Android Material guidelines.",
                    "Collaborated with product designers to implement pixel-perfect micro-animations.",
                ],
            },
        ],
        "projects": [
            {
                "name": "HabitPulse Fitness Tracker",
                "technologies": "Flutter, Dart, Firebase, SQLite",
                "bullets": [
                    "Published full-featured fitness habit tracking app on Google Play Store with 4.8-star user rating.",
                ],
            }
        ],
        "target_job": {
            "title": "Flutter Mobile Developer",
            "description": "Seeking a talented Flutter Developer proficient in Dart, Flutter, Firebase, and REST APIs. Experience with SQLite, Object-Oriented Programming, and mobile app performance optimization is essential.",
        },
    },

    # -------------------------------------------------------------
    # FIELD 3: Data Science, AI & Machine Learning
    # -------------------------------------------------------------
    {
        "field_id": "data_science_ai",
        "field_name": "Data Science & Artificial Intelligence",
        "position_id": "machine_learning_engineer",
        "position_title": "Machine Learning Engineer",
        "filename": "03_data_machine_learning_engineer.pdf",
        "candidate": {
            "name": "Dr. Marcus Bennett",
            "email": "m.bennett@ailabs.org",
            "phone": "(555) 912-4450",
            "location": "Boston, MA",
            "linkedin": "linkedin.com/in/marcus-bennett-ml",
            "github": "github.com/mbennett-ai",
        },
        "summary": "Machine Learning Engineer with strong theoretical and applied foundations in Deep Learning, Natural Language Processing, and Computer Vision. Experienced in training, fine-tuning, and production deployment of transformer and neural network architectures.",
        "education": [
            {
                "degree": "M.S. in Artificial Intelligence",
                "institution": "Boston University",
                "year": "2021",
                "details": "Thesis: Semantic Representation and Attention Optimization in Low-Resource NLP.",
            }
        ],
        "skills": {
            "ML & Deep Learning": "Machine Learning, Deep Learning, PyTorch, TensorFlow, Scikit-Learn",
            "Data Science": "Python, Pandas, NumPy, Data Analysis, Data Visualization",
            "Domains": "Natural Language Processing, Computer Vision, OpenCV",
            "Engineering & Cloud": "Docker, Git, REST APIs, FastAPI, Linux",
            "Databases": "PostgreSQL, MongoDB, Big Data",
        },
        "experience": [
            {
                "role": "Machine Learning Engineer",
                "company": "Cognitive AI Solutions",
                "period": "2022 — Present",
                "bullets": [
                    "Engineered end-to-end NLP classification pipelines in PyTorch and HuggingFace, improving accuracy to 93%.",
                    "Developed computer vision inspection models using OpenCV and deep convolutional neural networks.",
                    "Built feature extraction pipelines in Python using Pandas and NumPy for multi-gigabyte datasets.",
                    "Containerized trained models using Docker and served low-latency inferences via FastAPI REST APIs.",
                ],
            },
            {
                "role": "Data Scientist",
                "company": "Apex Analytics",
                "period": "2021 — 2022",
                "bullets": [
                    "Trained gradient boosting and regression models using Scikit-Learn on tabular business metrics.",
                    "Executed exploratory data analysis and hypothesis testing to uncover revenue churn drivers.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Real-time Medical Text Summarizer",
                "technologies": "PyTorch, Natural Language Processing, Docker",
                "bullets": [
                    "Fine-tuned transformer models for clinical summary generation with 91% ROUGE score agreement.",
                ],
            }
        ],
        "target_job": {
            "title": "Machine Learning Scientist",
            "description": "Looking for an ML Engineer skilled in Python, PyTorch, Scikit-Learn, Deep Learning, and Natural Language Processing. Candidates must demonstrate proficiency in Pandas, NumPy, and deploying models using Docker and REST APIs.",
        },
    },
    {
        "field_id": "data_science_ai",
        "field_name": "Data Science & Artificial Intelligence",
        "position_id": "bi_data_analyst",
        "position_title": "Business Intelligence & Data Analyst",
        "filename": "03_data_bi_analyst.pdf",
        "candidate": {
            "name": "Chloe Dupont",
            "email": "chloe.dupont@insightdata.net",
            "phone": "(555) 231-8765",
            "location": "New York, NY",
            "linkedin": "linkedin.com/in/chloedupont-data",
            "github": "github.com/cdupont-analytics",
        },
        "summary": "Results-oriented Data Analyst with 4 years translating raw complex transactional datasets into strategic executive dashboards. Expert in advanced SQL querying, interactive Power BI / Tableau reporting, and Python data wrangling.",
        "education": [
            {
                "degree": "B.S. in Business Analytics & Statistics",
                "institution": "New York University",
                "year": "2020",
                "details": "Summa Cum Laude. Focus on Applied Statistical Inference.",
            }
        ],
        "skills": {
            "Querying & Databases": "SQL, PostgreSQL, MySQL, Big Data",
            "Analytics & Programming": "Python, Pandas, NumPy, Data Analysis, R",
            "Visualization & BI": "Power BI, Tableau, Data Visualization, Microsoft Excel",
            "Business Competencies": "Financial Modeling, Market Research, Business Analysis",
            "Workflow": "Git, Jira, Agile Development",
        },
        "experience": [
            {
                "role": "Senior BI Analyst",
                "company": "Vanguard Strategic Retail",
                "period": "2022 — Present",
                "bullets": [
                    "Developed enterprise Power BI dashboards tracking $120M in omnichannel sales and inventory metrics.",
                    "Authored complex SQL queries with window functions and multi-table joins across 50M+ row PostgreSQL tables.",
                    "Automated weekly executive reporting pipelines using Python and Pandas, saving 15 manual hours weekly.",
                    "Conducted exploratory data analysis identifying customer retention opportunities that added $1.4M ARR.",
                ],
            },
            {
                "role": "Data Analyst",
                "company": "Metropolitan Marketing Group",
                "period": "2020 — 2022",
                "bullets": [
                    "Built interactive client dashboards in Tableau and conducted campaign attribution data analysis.",
                    "Managed financial modeling and scenario planning spreadsheets utilizing advanced Microsoft Excel functions.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Customer Lifetime Value (CLV) Predictor",
                "technologies": "SQL, Python, Pandas, Tableau",
                "bullets": [
                    "Modeled historical customer purchasing curves to forecast cohort lifetime values with 89% accuracy.",
                ],
            }
        ],
        "target_job": {
            "title": "Senior Data & BI Analyst",
            "description": "We are seeking a Business Intelligence Analyst with deep expertise in SQL, Power BI, Tableau, and Data Analysis. Experience in Python, Pandas, Data Visualization, and Microsoft Excel modeling is required.",
        },
    },

    # -------------------------------------------------------------
    # FIELD 4: Cloud Infrastructure & DevOps
    # -------------------------------------------------------------
    {
        "field_id": "cloud_devops",
        "field_name": "Cloud Infrastructure & DevOps",
        "position_id": "cloud_devops_engineer",
        "position_title": "Cloud Solutions & DevOps Engineer",
        "filename": "04_cloud_devops_engineer.pdf",
        "candidate": {
            "name": "Liam O'Connor",
            "email": "liam.oconnor@infraops.cloud",
            "phone": "(555) 774-5120",
            "location": "Denver, CO",
            "linkedin": "linkedin.com/in/liam-oconnor-devops",
            "github": "github.com/loconnor-ops",
        },
        "summary": "DevOps and Cloud Infrastructure Engineer with 5+ years building immutable multi-region cloud environments, CI/CD automated deployment engines, and Kubernetes container orchestration clusters on AWS.",
        "education": [
            {
                "degree": "B.S. in Computer Information Systems",
                "institution": "Colorado State University",
                "year": "2019",
                "details": "AWS Certified Solutions Architect — Associate.",
            }
        ],
        "skills": {
            "Cloud Providers": "AWS, Google Cloud, Microsoft Azure",
            "Containers & Orchestration": "Docker, Kubernetes",
            "IaC & Automation": "Terraform, CI/CD, Jenkins, Ansible",
            "Operating Systems & Scripting": "Linux, Bash, Python, Shell",
            "Platforms & Tools": "Git, GitHub, GitLab, Postman",
        },
        "experience": [
            {
                "role": "Senior DevOps Engineer",
                "company": "StratusCloud Infrastructure",
                "period": "2022 — Present",
                "bullets": [
                    "Architected production AWS infrastructure with Terraform, reducing infrastructure deployment time by 75%.",
                    "Orchestrated multi-cluster Kubernetes deployments with zero-downtime rolling upgrades and auto-scaling.",
                    "Designed automated CI/CD pipelines in GitLab and Jenkins supporting 60+ microservices deployments.",
                    "Standardized base Docker container images with multi-stage builds, cutting security vulnerabilities by 80%.",
                ],
            },
            {
                "role": "Cloud Support Specialist",
                "company": "PeakScale Networks",
                "period": "2019 — 2022",
                "bullets": [
                    "Managed high-availability Linux server fleets and automated routine patching using Bash and Shell scripts.",
                    "Configured AWS VPC peering, IAM permissions, EC2 instances, and S3 secure backup replication.",
                ],
            },
        ],
        "projects": [
            {
                "name": "GitOps Kubernetes Deployment Pipeline",
                "technologies": "Kubernetes, Docker, Terraform, AWS, CI/CD",
                "bullets": [
                    "Engineered automated GitOps declarative pipeline synchronizing repository commits directly to production.",
                ],
            }
        ],
        "target_job": {
            "title": "Cloud DevOps Engineer",
            "description": "Seeking a Cloud Engineer with extensive experience in AWS, Docker, Kubernetes, and CI/CD pipelines. Must be proficient in Terraform infrastructure-as-code, Linux system administration, Git, and Jenkins.",
        },
    },
    {
        "field_id": "cloud_devops",
        "field_name": "Cloud Infrastructure & DevOps",
        "position_id": "site_reliability_engineer",
        "position_title": "Site Reliability Engineer (SRE)",
        "filename": "04_cloud_site_reliability_engineer.pdf",
        "candidate": {
            "name": "Aisha Al-Mansoor",
            "email": "aisha.mansoor@reliability.net",
            "phone": "(555) 438-6612",
            "location": "Dallas, TX",
            "linkedin": "linkedin.com/in/aisha-sre",
            "github": "github.com/aisham-sre",
        },
        "summary": "Site Reliability Engineer focused on 99.99% service availability, observability architectures, SLO/SLI definition, and fault-tolerant system resilience across high-scale distributed microservices.",
        "education": [
            {
                "degree": "B.S. in Computer Science",
                "institution": "University of Texas at Dallas",
                "year": "2020",
                "details": "Specialization in Computer Networks and Operating Systems.",
            }
        ],
        "skills": {
            "Infrastructure & OS": "Linux, Docker, Kubernetes, AWS",
            "Automation & Code": "Python, Bash, Shell, Git, CI/CD",
            "Architecture": "System Design, Microservices, Object-Oriented Programming",
            "Networking & Reliability": "Debugging, Network Security, REST APIs",
            "Databases": "PostgreSQL, Redis, MySQL",
        },
        "experience": [
            {
                "role": "Site Reliability Engineer",
                "company": "Fintech Core Global",
                "period": "2022 — Present",
                "bullets": [
                    "Maintained 99.995% uptime across distributed banking microservices running on AWS and Kubernetes.",
                    "Automated incident remediation workflows using Python and Linux system daemons, reducing MTTR by 45%.",
                    "Conducted thorough post-mortem analyses, architectural system design reviews, and capacity planning drills.",
                    "Implemented distributed tracing and alerts across PostgreSQL databases and Redis caching tiers.",
                ],
            },
            {
                "role": "Infrastructure Systems Admin",
                "company": "Nexus Web Host",
                "period": "2020 — 2022",
                "bullets": [
                    "Administered Debian/RedHat Linux production servers with automated Bash hardening scripts.",
                    "Configured CI/CD test automation for infrastructure changes with Git version control.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Automated Chaos Engineering Simulator",
                "technologies": "Kubernetes, Docker, Python, Linux",
                "bullets": [
                    "Built chaos testing tool injecting network latency and pod termination to validate system failover.",
                ],
            }
        ],
        "target_job": {
            "title": "Site Reliability Engineer (SRE)",
            "description": "Looking for an SRE skilled in Linux, Kubernetes, Docker, and AWS. Must have strong programming skills in Python and Bash, and proven experience in System Design, Microservices reliability, and CI/CD.",
        },
    },

    # -------------------------------------------------------------
    # FIELD 5: Cybersecurity & Information Security
    # -------------------------------------------------------------
    {
        "field_id": "cybersecurity",
        "field_name": "Cybersecurity & Information Security",
        "position_id": "soc_security_analyst",
        "position_title": "SOC Operations & Incident Analyst",
        "filename": "05_cybersecurity_soc_analyst.pdf",
        "candidate": {
            "name": "Tariq Washington",
            "email": "tariq.sec@threatguard.org",
            "phone": "(555) 829-1044",
            "location": "Washington, DC",
            "linkedin": "linkedin.com/in/tariq-washington-sec",
            "github": "github.com/tariq-defend",
        },
        "summary": "Cybersecurity Operations Specialist with 4+ years protecting enterprise networks, monitoring SIEM consoles, leading incident response, and performing packet-level forensic threat analysis.",
        "education": [
            {
                "degree": "B.S. in Cybersecurity & Information Assurance",
                "institution": "George Mason University",
                "year": "2021",
                "details": "CompTIA Security+, CySA+ Certified.",
            }
        ],
        "skills": {
            "Security Operations": "SIEM, SOC Operations, Incident Response, Threat Analysis",
            "Network & Infrastructure": "Network Security, Firewalls, Wireshark, Linux",
            "Governance & Access": "Identity & Access Management (IAM), HIPAA Compliance",
            "Technical Assessment": "Vulnerability Assessment, OWASP, Cryptography",
            "Automation & Tools": "Python, Bash, Git",
        },
        "experience": [
            {
                "role": "Lead SOC Analyst",
                "company": "CyberShield Defense",
                "period": "2022 — Present",
                "bullets": [
                    "Monitored 24/7 SIEM platform correlating 500k+ daily security events across enterprise endpoints.",
                    "Spearheaded critical incident response investigations following NIST SP 800-61 containment protocols.",
                    "Analyzed suspicious network packets using Wireshark and configured next-gen Firewalls access control lists.",
                    "Automated threat analysis intelligence feeds using Python scripts and Linux cron workers.",
                ],
            },
            {
                "role": "Information Security Analyst",
                "company": "Federal Data Trust",
                "period": "2021 — 2022",
                "bullets": [
                    "Conducted monthly Vulnerability Assessment scans and verified remediation of critical CVE findings.",
                    "Audited Identity & Access Management (IAM) role permissions ensuring least-privilege compliance.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Automated Network Anomaly Detection Lab",
                "technologies": "Wireshark, Python, SIEM, Linux",
                "bullets": [
                    "Simulated unauthorized data exfiltration and built custom SIEM correlation rules to alert within 30s.",
                ],
            }
        ],
        "target_job": {
            "title": "Security Operations Center (SOC) Analyst",
            "description": "Seeking a dedicated Cybersecurity Analyst skilled in SIEM, Incident Response, Network Security, and Firewalls. Experience with Wireshark packet capture analysis, Threat Analysis, and Vulnerability Assessment is essential.",
        },
    },
    {
        "field_id": "cybersecurity",
        "field_name": "Cybersecurity & Information Security",
        "position_id": "application_security_engineer",
        "position_title": "Application Security Engineer",
        "filename": "05_cybersecurity_appsec_engineer.pdf",
        "candidate": {
            "name": "Elena Rostova",
            "email": "elena.rostova@secapp.io",
            "phone": "(555) 670-4491",
            "location": "Atlanta, GA",
            "linkedin": "linkedin.com/in/elena-rostova-appsec",
            "github": "github.com/erostova-sec",
        },
        "summary": "Application Security Engineer specializing in web and API vulnerability remediation, penetration testing, automated SAST/DAST pipeline integration, and threat modeling under OWASP standards.",
        "education": [
            {
                "degree": "B.S. in Computer Science",
                "institution": "Georgia Institute of Technology",
                "year": "2021",
                "details": "Certified Ethical Hacker (CEH), OSCP in progress.",
            }
        ],
        "skills": {
            "AppSec Core": "Penetration Testing, OWASP, Vulnerability Assessment, Secure Code Review",
            "Security Architecture": "Cryptography, Identity & Access Management (IAM), Network Security",
            "Programming": "Python, JavaScript, SQL, Bash",
            "Web & APIs": "REST APIs, Docker, Git, CI/CD",
            "Frameworks": "Linux, Postman, Software Testing",
        },
        "experience": [
            {
                "role": "Application Security Engineer",
                "company": "FinTech Guard Systems",
                "period": "2022 — Present",
                "bullets": [
                    "Executed Penetration Testing across web applications and REST APIs targeting OWASP Top 10 vulnerabilities.",
                    "Embedded automated Vulnerability Assessment checks into Git CI/CD pipelines to block insecure builds.",
                    "Conducted peer Secure Code Review for Python and JavaScript codebases identifying authentication bypasses.",
                    "Implemented Cryptography standards for data encryption-at-rest and enforced robust IAM policies.",
                ],
            },
            {
                "role": "Junior Security Specialist",
                "company": "SecureNet Consulting",
                "period": "2021 — 2022",
                "bullets": [
                    "Performed manual vulnerability scans and assisted in remediation of cross-site scripting (XSS) and SQLi.",
                    "Documented security testing playbooks and delivered developer secure coding training workshops.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Automated API Security Scanner",
                "technologies": "Python, OWASP, REST APIs, Docker",
                "bullets": [
                    "Built CLI tool that audits OpenAPI specifications for authentication loopholes and token leakage.",
                ],
            }
        ],
        "target_job": {
            "title": "Application Security Engineer",
            "description": "Looking for an Application Security Engineer proficient in Penetration Testing, OWASP, Vulnerability Assessment, and Secure Code Review. Experience with Cryptography, Identity & Access Management (IAM), and Python is required.",
        },
    },

    # -------------------------------------------------------------
    # FIELD 6: Civil & Structural Engineering
    # -------------------------------------------------------------
    {
        "field_id": "civil_engineering",
        "field_name": "Civil & Structural Engineering",
        "position_id": "structural_design_engineer",
        "position_title": "Structural Design Engineer",
        "filename": "06_civil_structural_engineer.pdf",
        "candidate": {
            "name": "Carlos Mendoza",
            "email": "c.mendoza@structures.net",
            "phone": "(555) 492-7105",
            "location": "Houston, TX",
            "linkedin": "linkedin.com/in/carlos-mendoza-ce",
            "github": "github.com/cmendoza-civil",
        },
        "summary": "Licensed Structural Design Engineer with 5+ years experience in multi-story reinforced concrete and steel frame design, finite element load analysis, and seismic compliance modeling in AutoCAD and STAAD.Pro.",
        "education": [
            {
                "degree": "B.S. in Civil Engineering",
                "institution": "University of Houston",
                "year": "2020",
                "details": "EIT Certified, Structural Engineering Focus.",
            }
        ],
        "skills": {
            "Design & CAD": "AutoCAD, STAAD.Pro, Revit, Building Information Modeling (BIM)",
            "Structural Analysis": "Structural Analysis, Concrete Technology, Steel Structures",
            "Geotechnical & Site": "Geotechnical Engineering, Foundation Engineering, Surveying",
            "Project Management": "Estimation & Costing, Site Safety, Total Station",
            "Code Compliance": "IS 456, ACI 318, AISC Standards",
        },
        "experience": [
            {
                "role": "Lead Structural Engineer",
                "company": "Apex Structural Consultants",
                "period": "2022 — Present",
                "bullets": [
                    "Performed structural analysis and 3D modeling for 12 commercial reinforced concrete buildings in STAAD.Pro.",
                    "Drafted detailed engineering blueprints and fabrication schedules in AutoCAD and Revit BIM environments.",
                    "Calculated dead, live, wind, and seismic load distributions following ACI 318 and IBC building codes.",
                    "Inspected foundation engineering pouring and concrete technology compressive strength tests on-site.",
                ],
            },
            {
                "role": "Junior Civil Engineer",
                "company": "Metro Infrastructure Builders",
                "period": "2020 — 2022",
                "bullets": [
                    "Conducted land surveying with Total Station instruments and plotted topographical contour elevations.",
                    "Prepared preliminary estimation & costing quantities for commercial steel structures.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Seismic Retrofit of Mid-Rise Commercial Complex",
                "technologies": "STAAD.Pro, AutoCAD, Structural Analysis, Revit",
                "bullets": [
                    "Designed shear wall reinforcements in STAAD.Pro mitigating lateral drift by 38% under seismic simulation.",
                ],
            }
        ],
        "target_job": {
            "title": "Senior Structural Engineer",
            "description": "Seeking an experienced Structural Engineer skilled in AutoCAD, STAAD.Pro, Structural Analysis, and Revit. Candidates must demonstrate deep knowledge of Concrete Technology, Steel Structures, and Geotechnical Engineering.",
        },
    },
    {
        "field_id": "civil_engineering",
        "field_name": "Civil & Structural Engineering",
        "position_id": "construction_safety_manager",
        "position_title": "Construction Project & Safety Manager",
        "filename": "06_civil_construction_safety_manager.pdf",
        "candidate": {
            "name": "Rachel Zimmerman",
            "email": "rachel.zimmerman@buildsafe.org",
            "phone": "(555) 718-9940",
            "location": "Phoenix, AZ",
            "linkedin": "linkedin.com/in/rachel-zimmerman-safety",
            "github": "github.com/rzimmerman-build",
        },
        "summary": "Civil Construction Manager with 6+ years overseeing commercial site safety compliance, contractor coordination, critical path CPM scheduling in Primavera P6, and BIM clash detection.",
        "education": [
            {
                "degree": "B.S. in Construction Management",
                "institution": "Arizona State University",
                "year": "2019",
                "details": "OSHA 30-Hour Construction Safety Certified.",
            }
        ],
        "skills": {
            "Safety & Regulation": "Site Safety, Risk Management, OSHA Compliance, Inspection",
            "Scheduling & Planning": "Primavera P6, Project Scheduling, Project Management",
            "Design & BIM": "Building Information Modeling (BIM), Revit, AutoCAD",
            "Cost & Estimation": "Estimation & Costing, Quantity Surveying, Budgeting",
            "Civil Fieldwork": "Surveying, Concrete Technology, Highway Engineering",
        },
        "experience": [
            {
                "role": "Construction Safety & Project Manager",
                "company": "Desert Ridge Contractors",
                "period": "2021 — Present",
                "bullets": [
                    "Managed on-site safety compliance and job hazard analyses across a $45M commercial hospital build.",
                    "Created and tracked CPM master schedules using Primavera P6 with zero unmitigated timeline slippages.",
                    "Coordinated MEP trade clash detection meetings utilizing Building Information Modeling (BIM) in Revit.",
                    "Supervised quantity surveying and estimation & costing verifications for monthly contractor billing.",
                ],
            },
            {
                "role": "Field Project Engineer",
                "company": "Southwest Highway Partners",
                "period": "2019 — 2021",
                "bullets": [
                    "Conducted daily site safety inspections and enforced mandatory PPE protocols across highway paving sites.",
                    "Maintained submittal logs and performed material quality tests for concrete technology compliance.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Zero-Incident Commercial Tower Project",
                "technologies": "Primavera P6, Site Safety, Building Information Modeling (BIM)",
                "bullets": [
                    "Achieved 450,000 safe worker-hours without a single lost-time injury incident on high-rise build.",
                ],
            }
        ],
        "target_job": {
            "title": "Construction Project Manager",
            "description": "Hiring a Construction Project Manager experienced in Site Safety, Primavera P6, and Building Information Modeling (BIM). Strong skills in Estimation & Costing, Quantity Surveying, and AutoCAD are required.",
        },
    },

    # -------------------------------------------------------------
    # FIELD 7: 3D Animation & Digital Media
    # -------------------------------------------------------------
    {
        "field_id": "animation_media",
        "field_name": "3D Animation & Digital Media",
        "position_id": "character_animator_rigging",
        "position_title": "3D Character Animator & Rigging Artist",
        "filename": "07_animation_3d_character_animator.pdf",
        "candidate": {
            "name": "Leo Takahashi",
            "email": "leo.takahashi@animfx.studio",
            "phone": "(555) 902-3318",
            "location": "Los Angeles, CA",
            "linkedin": "linkedin.com/in/leo-takahashi-anim",
            "github": "github.com/ltakahashi-art",
        },
        "summary": "Lead 3D Character Animator and Rigging Artist with 5+ years animating expressive stylized and realistic characters in Blender and Maya. Expert in squash & stretch principles, IK/FK rigging setups, and facial deformation controls.",
        "education": [
            {
                "degree": "B.F.A. in Computer Animation",
                "institution": "California Institute of the Arts (CalArts)",
                "year": "2020",
                "details": "Excellence in Character Animation Award.",
            }
        ],
        "skills": {
            "3D Software": "Blender, Maya, 3ds Max, Cinema 4D, ZBrush",
            "Animation & Rigging": "Character Animation, Rigging, Keyframing, Storyboarding",
            "Assets & Shading": "3D Modeling, Texturing, UV Unwrapping, Lighting & Rendering",
            "Game Engines & Digital": "Unreal Engine, Motion Graphics, After Effects",
            "Core Principles": "Timing and Spacing, Weight Shifts, Facial Expressions",
        },
        "experience": [
            {
                "role": "Senior Character Animator",
                "company": "Moonlight Animation Studios",
                "period": "2022 — Present",
                "bullets": [
                    "Animated hero character shots in Maya adhering strictly to the 12 Principles of Animation.",
                    "Engineered complex bipedal and creature character rigs featuring dual IK/FK spine and arm switching in Blender.",
                    "Sculpted dynamic facial blendshapes in ZBrush for emotional dialogue scenes and lip-sync precision.",
                    "Collaborated with game engine developers to export clean FBX animation cycles into Unreal Engine.",
                ],
            },
            {
                "role": "3D Generalist & Rigger",
                "company": "Kitefly Interactive",
                "period": "2020 — 2022",
                "bullets": [
                    "Built stylized 3D modeling assets, UV unwrapping maps, and procedural materials in Blender.",
                    "Keyframed secondary prop animations and set up camera layout staging from initial storyboards.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Animated Short Film 'Clockwork Dragon'",
                "technologies": "Blender, Maya, Rigging, Character Animation",
                "bullets": [
                    "Directed 4-minute CG short featuring full custom quadruped mechanical dragon rig and keyframe animation.",
                ],
            }
        ],
        "target_job": {
            "title": "Lead 3D Character Animator",
            "description": "Seeking an extraordinary 3D Animator skilled in Blender, Maya, Rigging, Keyframing, and Character Animation. Experience with 3D Modeling, Texturing, Storyboarding, and Unreal Engine is a strong advantage.",
        },
    },
    {
        "field_id": "animation_media",
        "field_name": "3D Animation & Digital Media",
        "position_id": "motion_graphics_vfx_artist",
        "position_title": "Motion Graphics & VFX Compositor",
        "filename": "07_animation_motion_graphics_vfx.pdf",
        "candidate": {
            "name": "Zoe Kravitz",
            "email": "zoe.kravitz@visualpost.tv",
            "phone": "(555) 314-8790",
            "location": "Burbank, CA",
            "linkedin": "linkedin.com/in/zoe-kravitz-motion",
            "github": "github.com/zkravitz-motion",
        },
        "summary": "Motion Graphics Designer and Visual Effects Compositor with 4 years creating broadcast title sequences, dynamic commercial kinetic typography, multi-pass 3D compositing, and visual effects in After Effects and Cinema 4D.",
        "education": [
            {
                "degree": "B.A. in Digital Arts & Motion Media",
                "institution": "Savannah College of Art and Design (SCAD)",
                "year": "2021",
                "details": "Specialization in Visual Effects and Commercial Broadcast Design.",
            }
        ],
        "skills": {
            "Motion & Compositing": "Motion Graphics, After Effects, Cinema 4D, Compositing, VFX",
            "Video Editing": "Premiere Pro, Keyframing, Storyboarding, Concept Art",
            "3D Software": "Blender, 3D Modeling, Lighting & Rendering, 3ds Max",
            "Design Tools": "Photoshop, Illustrator, Figma",
            "Techniques": "Rotoscoping, Green Screen Keying, Particle Simulations",
        },
        "experience": [
            {
                "role": "Motion Graphics & VFX Artist",
                "company": "Vivid Wave Post-Production",
                "period": "2022 — Present",
                "bullets": [
                    "Created commercial broadcast motion graphics packages using After Effects and Cinema 4D MoGraph.",
                    "Executed node-based compositing and VFX plate cleanups for national streaming advertisements.",
                    "Designed dynamic kinetic typography, logo reveals, and animated product teasers in Premiere Pro.",
                    "Developed storyboards and animatic timing previews communicating visual flow to brand directors.",
                ],
            },
            {
                "role": "Junior Motion Designer",
                "company": "Prism Creative Agency",
                "period": "2021 — 2022",
                "bullets": [
                    "Animated 2D vector infographic assets and social media video promos in Adobe After Effects.",
                    "Modeled simple 3D product renders in Blender with realistic lighting and physical materials.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Broadcast Brand Identity Package",
                "technologies": "After Effects, Cinema 4D, Motion Graphics, VFX",
                "bullets": [
                    "Designed complete visual broadcast package with 3D lower thirds, bumpers, and animated stingers.",
                ],
            }
        ],
        "target_job": {
            "title": "Senior Motion Graphics & VFX Designer",
            "description": "Looking for a Motion Designer proficient in After Effects, Cinema 4D, Motion Graphics, and Compositing. Must have experience with VFX integration, Premiere Pro editing, Storyboarding, and 3D Modeling.",
        },
    },

    # -------------------------------------------------------------
    # FIELD 8: Healthcare & Registered Nursing
    # -------------------------------------------------------------
    {
        "field_id": "healthcare_nursing",
        "field_name": "Healthcare & Registered Nursing",
        "position_id": "emergency_icu_nurse",
        "position_title": "Emergency & ICU Staff Nurse",
        "filename": "08_healthcare_emergency_icu_nurse.pdf",
        "candidate": {
            "name": "Sarah Jenkins, BSN, RN",
            "email": "sarah.jenkins.rn@healthmail.org",
            "phone": "(555) 581-2093",
            "location": "Philadelphia, PA",
            "linkedin": "linkedin.com/in/sarah-jenkins-rn",
            "github": "github.com/sjenkins-nurse",
        },
        "summary": "Registered Nurse with 5+ years of acute trauma and intensive care experience. Certified in BLS, ACLS, and PALS with clinical mastery in rapid emergency patient triage, invasive hemodynamic monitoring, and rapid code team response.",
        "education": [
            {
                "degree": "Bachelor of Science in Nursing (BSN)",
                "institution": "University of Pennsylvania School of Nursing",
                "year": "2020",
                "details": "Licensed Registered Nurse (PA State Board of Nursing), Magna Cum Laude.",
            }
        ],
        "skills": {
            "Certifications": "BLS Certification, ACLS Certification, PALS Certification, CPR",
            "Clinical Care": "Patient Triage, Critical Care, Vital Signs Monitoring, IV Cannulation",
            "Medication & Safety": "Medication Administration, Pharmacology, Wound Care",
            "Systems & Compliance": "EHR/EMR Charting, HIPAA Compliance, Infection Control",
            "Documentation": "Clinical Documentation, Patient Assessment, Patient Advocacy",
        },
        "experience": [
            {
                "role": "Emergency Room Staff Nurse",
                "company": "Penn Trauma & Medical Center",
                "period": "2022 — Present",
                "bullets": [
                    "Performed rapid patient triage in Level 1 Emergency Department adhering to Emergency Severity Index (ESI).",
                    "Monitored critical vital signs monitoring telemetry and managed ventilators in ICU critical care settings.",
                    "Administered emergency cardiovascular pharmacology and IV cannulation under ACLS code protocols.",
                    "Maintained 100% HIPAA compliance while completing real-time clinical documentation in Epic EHR systems.",
                ],
            },
            {
                "role": "Medical-Surgical Staff Nurse",
                "company": "Mercy Community Hospital",
                "period": "2020 — 2022",
                "bullets": [
                    "Delivered direct patient care including sterile wound care, medication administration, and IV therapy.",
                    "Educated patients and families on post-discharge treatment plans while advocating for patient needs.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Rapid Sepsis Intervention Protocol",
                "technologies": "Patient Triage, EHR/EMR Charting, Clinical Documentation",
                "bullets": [
                    "Collaborated on unit-based initiative reducing time-to-antibiotic administration by 35 minutes.",
                ],
            }
        ],
        "target_job": {
            "title": "Emergency Department Staff Nurse (RN)",
            "description": "We are seeking an Emergency Department RN with active BLS Certification and ACLS Certification. Requirements include expertise in Patient Triage, Vital Signs Monitoring, Critical Care, IV Cannulation, and EHR/EMR Charting.",
        },
    },
    {
        "field_id": "healthcare_nursing",
        "field_name": "Healthcare & Registered Nursing",
        "position_id": "clinical_nurse_specialist",
        "position_title": "Clinical Nurse Specialist & Quality Coordinator",
        "filename": "08_healthcare_clinical_ehr_specialist.pdf",
        "candidate": {
            "name": "David Kim, MSN, RN",
            "email": "david.kim.msn@nursingcare.com",
            "phone": "(555) 743-8821",
            "location": "Cleveland, OH",
            "linkedin": "linkedin.com/in/david-kim-msn",
            "github": "github.com/dkim-clinical",
        },
        "summary": "Master's-prepared Clinical Nurse Specialist with 6+ years driving hospital-wide infection control standards, electronic health record (EHR) workflows, medication administration error prevention, and patient advocacy.",
        "education": [
            {
                "degree": "Master of Science in Nursing (MSN) — Healthcare Leadership",
                "institution": "Case Western Reserve University",
                "year": "2021",
                "details": "BSN from Ohio State University (2018).",
            }
        ],
        "skills": {
            "Systems & Regulation": "EHR/EMR Charting, HIPAA Compliance, Infection Control, Medical Terminology",
            "Clinical Standards": "Medication Administration, Pharmacology, Patient Assessment, Wound Care",
            "Certifications": "BLS Certification, CPR, Clinical Documentation",
            "Leadership & Process": "Patient Advocacy, Phlebotomy, Project Management",
            "Documentation": "Epic Systems, Cerner, Audit & Quality Improvement",
        },
        "experience": [
            {
                "role": "Clinical Nurse Specialist & EHR Coordinator",
                "company": "Cleveland Regional Health System",
                "period": "2022 — Present",
                "bullets": [
                    "Optimized inpatient EHR/EMR charting templates in Epic, reducing duplicate documentation entry by 25%.",
                    "Audited medication administration workflows ensuring strict compliance with the 6 Rights of Medication.",
                    "Led multidisciplinary infection control committees that decreased hospital-acquired infections (HAI) by 18%.",
                    "Conducted departmental education on HIPAA compliance and clinical documentation accuracy.",
                ],
            },
            {
                "role": "Clinical Staff Nurse",
                "company": "St. Luke's Health Center",
                "period": "2019 — 2022",
                "bullets": [
                    "Conducted comprehensive patient assessment exams and managed complex dressing changes for surgical wound care.",
                    "Maintained current BLS certification and served as preceptor for newly hired registered nurses.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Hospital-Wide Infection Prevention Campaign",
                "technologies": "Infection Control, EHR/EMR Charting, Clinical Documentation",
                "bullets": [
                    "Standardized central line dressing change kits, achieving 0 CLABSI incidents across 12 consecutive months.",
                ],
            }
        ],
        "target_job": {
            "title": "Clinical Nurse Specialist / Nurse Educator",
            "description": "Seeking an MSN-qualified Clinical Nurse Specialist. Must possess expertise in EHR/EMR Charting, HIPAA Compliance, Medication Administration, Infection Control, and Clinical Documentation. BLS Certification required.",
        },
    },

    # -------------------------------------------------------------
    # FIELD 9: Product Management & Business Analysis
    # -------------------------------------------------------------
    {
        "field_id": "product_management",
        "field_name": "Product Management & Business Analysis",
        "position_id": "technical_product_manager",
        "position_title": "Technical Product Manager",
        "filename": "09_business_technical_product_manager.pdf",
        "candidate": {
            "name": "Sophia Sterling",
            "email": "sophia.sterling@prodmgmt.io",
            "phone": "(555) 890-3312",
            "location": "San Francisco, CA",
            "linkedin": "linkedin.com/in/sophia-sterling-pm",
            "github": "github.com/ssterling-pm",
        },
        "summary": "Technical Product Manager with 5+ years translating complex developer platforms into revenue-generating SaaS products. Certified Scrum Product Owner (CSPO) experienced in product roadmap strategy, PRDs, and user research.",
        "education": [
            {
                "degree": "B.S. in Computer Science & Business Management",
                "institution": "University of California, Berkeley",
                "year": "2020",
                "details": "CSPO Certified, Product School Alumni.",
            }
        ],
        "skills": {
            "Product Strategy": "Agile Development, Scrum, Strategic Planning, Project Management",
            "Analysis & Discovery": "Business Analysis, Market Research, User Research, Data Analysis",
            "Technical Literacy": "System Design, REST APIs, SQL, Data Structures",
            "Tools & Operations": "Jira, Figma, Microsoft Excel, Risk Management",
            "Execution": "PRD Writing, Feature Prioritization, OKR Tracking",
        },
        "experience": [
            {
                "role": "Senior Product Manager",
                "company": "CloudScale Platforms",
                "period": "2022 — Present",
                "bullets": [
                    "Owned developer API platform roadmap increasing annual platform revenue from $4M to $11.5M.",
                    "Led cross-functional engineering pods through bi-weekly Agile Development and Scrum sprint ceremonies in Jira.",
                    "Collaborated with architects on system design and REST APIs schema deprecation strategies.",
                    "Analyzed customer cohort telemetry using SQL and data analysis to prioritize feature backlog.",
                ],
            },
            {
                "role": "Associate Product Manager",
                "company": "Nova Interactive",
                "period": "2020 — 2022",
                "bullets": [
                    "Authored comprehensive PRDs and user stories for consumer mobile checkout flows.",
                    "Conducted competitive market research and user research surveys defining core product positioning.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Self-Serve Developer Sandbox Portal",
                "technologies": "Agile Development, REST APIs, Jira, Figma",
                "bullets": [
                    "Launched interactive sandbox cutting enterprise developer onboarding integration time from 3 weeks to 2 days.",
                ],
            }
        ],
        "target_job": {
            "title": "Technical Product Manager",
            "description": "We are seeking a Technical Product Manager skilled in Agile Development, Scrum, System Design, and Project Management. Must have proven experience with Strategic Planning, Jira, SQL, and user-centric discovery.",
        },
    },
    {
        "field_id": "product_management",
        "field_name": "Product Management & Business Analysis",
        "position_id": "business_systems_analyst",
        "position_title": "Senior Business Systems Analyst",
        "filename": "09_business_systems_analyst.pdf",
        "candidate": {
            "name": "Vikram Seth",
            "email": "vikram.seth@enterpriseops.net",
            "phone": "(555) 412-9905",
            "location": "Charlotte, NC",
            "linkedin": "linkedin.com/in/vikram-seth-ba",
            "github": "github.com/vseth-analyst",
        },
        "summary": "Business Systems Analyst with 5+ years bridging business stakeholders and engineering teams. Expert in business process modeling (BPMN), requirements elicitation, SQL gap analysis, and ERP/CRM system implementations.",
        "education": [
            {
                "degree": "B.S. in Management Information Systems",
                "institution": "University of North Carolina at Chapel Hill",
                "year": "2020",
                "details": "Certified Business Analysis Professional (CBAP).",
            }
        ],
        "skills": {
            "Business Analysis": "Business Analysis, Project Management, Risk Management, Strategic Planning",
            "Data & Querying": "SQL, Data Analysis, Microsoft Excel, Financial Modeling",
            "Process & Systems": "System Design, Agile Development, Scrum",
            "Documentation": "Use Cases, Business Requirements Document (BRD), GAP Analysis",
            "Tools": "Jira, Postman, Power BI",
        },
        "experience": [
            {
                "role": "Lead Business Systems Analyst",
                "company": "Pinnacle Financial Operations",
                "period": "2022 — Present",
                "bullets": [
                    "Elicited and documented 140+ functional requirements for cloud core billing migration.",
                    "Executed SQL verification scripts against enterprise data warehouses to validate data migration integrity.",
                    "Constructed detailed BPMN workflow diagrams and led user acceptance testing (UAT) sessions.",
                    "Managed project risk management registers and mitigated scope creep in collaboration with PMO.",
                ],
            },
            {
                "role": "Business Analyst",
                "company": "BlueRidge Tech Solutions",
                "period": "2020 — 2022",
                "bullets": [
                    "Formulated business analysis reports and financial modeling spreadsheets using advanced Microsoft Excel.",
                    "Facilitated sprint planning and backlog grooming meetings under Agile Development frameworks.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Enterprise Billing Transformation",
                "technologies": "Business Analysis, SQL, Agile Development, Project Management",
                "bullets": [
                    "Streamlined automated invoicing workflows reducing monthly reconciliation discrepancies by 68%.",
                ],
            }
        ],
        "target_job": {
            "title": "Senior Business Analyst",
            "description": "Looking for a Business Analyst with strong skills in Business Analysis, SQL, Project Management, and Risk Management. Must be adept in Agile Development, Microsoft Excel, and creating detailed functional specifications.",
        },
    },

    # -------------------------------------------------------------
    # FIELD 10: Finance, Accounting & Investment Banking
    # -------------------------------------------------------------
    {
        "field_id": "finance_accounting",
        "field_name": "Finance, Accounting & Investment Banking",
        "position_id": "investment_financial_analyst",
        "position_title": "Investment & Financial Analyst",
        "filename": "10_finance_investment_analyst.pdf",
        "candidate": {
            "name": "Arthur Pendelton",
            "email": "arthur.pendelton@capitalpartners.com",
            "phone": "(555) 789-4011",
            "location": "New York, NY",
            "linkedin": "linkedin.com/in/arthur-pendelton-finance",
            "github": "github.com/apendelton-fin",
        },
        "summary": "Financial Analyst with 4+ years in corporate finance and M&A valuation. Proven ability building 3-statement financial models, discounted cash flow (DCF) analyses, leveraged buyout (LBO) frameworks, and executive pitch decks in Excel.",
        "education": [
            {
                "degree": "B.S. in Finance & Economics",
                "institution": "Columbia University",
                "year": "2021",
                "details": "CFA Level II Candidate, Magna Cum Laude.",
            }
        ],
        "skills": {
            "Valuation & Modeling": "Financial Modeling, Valuation, Corporate Finance, Portfolio Management",
            "Analysis & Risk": "Risk Management, Budgeting, Financial Reporting, Market Research",
            "Tools & Spreadsheets": "Microsoft Excel, Power BI, SQL, Python",
            "Accounting Foundations": "Accounting, Auditing, General Ledger",
            "Core Competencies": "DCF Modeling, LBO Analysis, Scenario Testing",
        },
        "experience": [
            {
                "role": "Senior Financial Analyst",
                "company": "Gotham Capital Partners",
                "period": "2022 — Present",
                "bullets": [
                    "Constructed dynamic 3-statement financial modeling spreadsheets and DCF valuation models for $250M+ targets.",
                    "Executed sensitivity analysis and corporate finance risk management models evaluating debt capacity.",
                    "Prepared quarterly board decks and financial reporting summaries comparing actuals against projected budgets.",
                    "Automated valuation peer comps using Python scripts and advanced Microsoft Excel functions.",
                ],
            },
            {
                "role": "Investment Banking Analyst",
                "company": "Wall Street Securities",
                "period": "2021 — 2022",
                "bullets": [
                    "Assisted in underwriting M&A transactions through detailed precedent transaction and valuation multiples.",
                    "Conducted in-depth market research on fintech and healthcare industry consolidation trends.",
                ],
            },
        ],
        "projects": [
            {
                "name": "LBO Acquisition Valuation Model",
                "technologies": "Financial Modeling, Valuation, Microsoft Excel, Corporate Finance",
                "bullets": [
                    "Modeled 5-year debt paydown and IRR returns across multiple exit multiples for private equity buyout.",
                ],
            }
        ],
        "target_job": {
            "title": "Senior Financial Analyst",
            "description": "Seeking a Financial Analyst with proven expertise in Financial Modeling, Valuation, Microsoft Excel, and Budgeting. Experience in Corporate Finance, Risk Management, and Financial Reporting is essential.",
        },
    },
    {
        "field_id": "finance_accounting",
        "field_name": "Finance, Accounting & Investment Banking",
        "position_id": "corporate_accountant_auditor",
        "position_title": "Corporate Accountant & Auditor",
        "filename": "10_finance_corporate_accountant.pdf",
        "candidate": {
            "name": "Natalie Brooks, CPA",
            "email": "natalie.brooks.cpa@acctadvisory.com",
            "phone": "(555) 624-9108",
            "location": "Chicago, IL",
            "linkedin": "linkedin.com/in/natalie-brooks-cpa",
            "github": "github.com/nbrooks-cpa",
        },
        "summary": "Certified Public Accountant (CPA) with 5+ years experience managing general ledger accounting, month-end closing, GAAP/SOX compliance, internal financial audits, and state/federal tax compliance.",
        "education": [
            {
                "degree": "B.S. in Accounting & Master of Accounting (MAcc)",
                "institution": "University of Michigan — Ross School of Business",
                "year": "2020",
                "details": "Licensed CPA (State of Illinois).",
            }
        ],
        "skills": {
            "Accounting Core": "Accounting, General Ledger, Financial Reporting, Auditing",
            "Compliance & Tax": "Tax Compliance, Risk Management, GAAP, SOX",
            "Finance & Planning": "Budgeting, Financial Modeling, Corporate Finance",
            "Software & Tools": "Microsoft Excel, ERP Systems, SQL, QuickBooks",
            "Competencies": "Balance Sheet Reconciliation, Journal Entries, Trial Balance",
        },
        "experience": [
            {
                "role": "Senior Corporate Accountant",
                "company": "Midwest Industrial Supply",
                "period": "2022 — Present",
                "bullets": [
                    "Oversaw general ledger operations and managed monthly closing cycles across 6 subsidiary operating units.",
                    "Prepared audited financial reporting statements (Balance Sheet, Income Statement, Cash Flows) under GAAP.",
                    "Coordinated annual external auditing reviews and resolved variance discrepancies with zero material findings.",
                    "Ensured strict tax compliance with quarterly state sales tax and federal corporate filing obligations.",
                ],
            },
            {
                "role": "Staff Auditor",
                "company": "KPMG US",
                "period": "2020 — 2022",
                "bullets": [
                    "Executed substantive audit testing of accounts receivable, revenue recognition, and internal control testing.",
                    "Automated trial balance reconciliation schedules utilizing advanced Microsoft Excel macros and VLOOKUPs.",
                ],
            },
        ],
        "projects": [
            {
                "name": "SOX Compliance & Automated GL Reconciliation",
                "technologies": "Accounting, General Ledger, Auditing, Microsoft Excel",
                "bullets": [
                    "Redesigned sub-ledger posting workflow reducing manual journal entries by 40% and cutting month-end close by 2 days.",
                ],
            }
        ],
        "target_job": {
            "title": "Senior Corporate Accountant",
            "description": "We are seeking a CPA or Senior Accountant experienced in Accounting, General Ledger, Financial Reporting, and Auditing. Must possess strong mastery of Tax Compliance, Budgeting, and Microsoft Excel.",
        },
    },

    # -------------------------------------------------------------
    # FIELD 11: UI/UX Product Design
    # -------------------------------------------------------------
    {
        "field_id": "product_design",
        "field_name": "UI/UX Product Design",
        "position_id": "lead_uiux_designer",
        "position_title": "Lead UI/UX Product Designer",
        "filename": "11_design_senior_uiux_designer.pdf",
        "candidate": {
            "name": "Hannah Kim",
            "email": "hannah.kim@designstudio.io",
            "phone": "(555) 308-5524",
            "location": "Seattle, WA",
            "linkedin": "linkedin.com/in/hannah-kim-uiux",
            "github": "github.com/hkim-ux",
        },
        "summary": "Lead Product Designer with 6+ years creating intuitive mobile and desktop software experiences. Master of Figma auto-layout, scalable design systems, wireframing, high-fidelity prototyping, and user-centered design methodologies.",
        "education": [
            {
                "degree": "B.Des in Interaction Design",
                "institution": "University of Washington",
                "year": "2019",
                "details": "Specialization in Visual Systems and Human-Computer Interaction.",
            }
        ],
        "skills": {
            "Design Tools": "Figma, Sketch, Adobe XD, Illustrator, Photoshop",
            "UI/UX Practices": "UI/UX Design, Wireframing, Prototyping, Design Systems",
            "Research & Testing": "User Research, Usability Testing, User Flows, Information Architecture",
            "Front-End Awareness": "HTML, CSS, Responsive Design, Motion Graphics",
            "Principles": "Accessibility (WCAG 2.1 AA), Typography, Visual Hierarchy",
        },
        "experience": [
            {
                "role": "Lead Product Designer",
                "company": "Zenith Cloud Software",
                "period": "2022 — Present",
                "bullets": [
                    "Built comprehensive multi-brand design systems in Figma supporting 50+ enterprise product engineers.",
                    "Created interactive high-fidelity prototyping mockups simulating micro-interactions and complex user flows.",
                    "Conducted remote usability testing and synthesized findings into actionable UI/UX design refinements.",
                    "Collaborated with developers ensuring 100% fidelity handoff and WCAG 2.1 AA accessibility compliance.",
                ],
            },
            {
                "role": "UI/UX Designer",
                "company": "Nordic Digital Labs",
                "period": "2019 — 2022",
                "bullets": [
                    "Drafted low-fidelity wireframing concepts and user journeys for consumer mobile banking applications.",
                    "Facilitated design sprint workshops and created clickable prototypes for executive stakeholder buy-in.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Enterprise Design Token Architecture",
                "technologies": "Figma, Design Systems, UI/UX Design, Prototyping",
                "bullets": [
                    "Standardized semantic color and typography tokens cutting frontend design revision cycles by 50%.",
                ],
            }
        ],
        "target_job": {
            "title": "Senior UI/UX Product Designer",
            "description": "Seeking an exceptional Product Designer proficient in Figma, UI/UX Design, Wireframing, and Prototyping. Strong portfolio demonstrating Design Systems, User Research, Usability Testing, and User Flows is required.",
        },
    },
    {
        "field_id": "product_design",
        "field_name": "UI/UX Product Design",
        "position_id": "usability_interaction_specialist",
        "position_title": "UX Researcher & Usability Specialist",
        "filename": "11_design_product_interaction_designer.pdf",
        "candidate": {
            "name": "Lucas Moreau",
            "email": "lucas.moreau@uxinsights.com",
            "phone": "(555) 751-2290",
            "location": "Boston, MA",
            "linkedin": "linkedin.com/in/lucas-moreau-uxr",
            "github": "github.com/lmoreau-ux",
        },
        "summary": "UX Researcher with 5 years leading generative discovery and evaluative usability testing for healthcare and fintech platforms. Expert in qualitative user interviews, card sorting, information architecture, and behavioral analytics.",
        "education": [
            {
                "degree": "M.S. in Human Factors & Cognitive Psychology",
                "institution": "Tufts University",
                "year": "2020",
                "details": "B.A. in Psychology from Boston College (2018).",
            }
        ],
        "skills": {
            "UX Research": "User Research, Usability Testing, Information Architecture, User Flows",
            "Design Tools": "Figma, Wireframing, Prototyping, UI/UX Design",
            "Methodologies": "Heuristic Evaluation, Card Sorting, Survey Design, Persona Creation",
            "Analytics & Collaboration": "Data Analysis, Agile Development, Jira, User Advocacy",
            "Standards": "WCAG Accessibility, Cognitive Walkthroughs, SUS Scoring",
        },
        "experience": [
            {
                "role": "Senior UX Researcher",
                "company": "Beacon Health Informatics",
                "period": "2022 — Present",
                "bullets": [
                    "Planned and moderated 120+ usability testing interviews evaluating physician EHR interface workflows.",
                    "Restructured enterprise platform information architecture through card sorting, boosting findability by 44%.",
                    "Synthesized qualitative user research feedback into actionable persona maps and prioritized UX backlogs.",
                    "Built low-fidelity prototyping variants in Figma to test cognitive load across alternative user flows.",
                ],
            },
            {
                "role": "UX Research Associate",
                "company": "Cognitive Metrics",
                "period": "2020 — 2022",
                "bullets": [
                    "Conducted heuristic evaluations and benchmarked System Usability Scale (SUS) scores across web portals.",
                    "Created journey maps and wireframing specs highlighting friction points in sign-up funnels.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Physician Clinical Workflow Redesign",
                "technologies": "User Research, Usability Testing, Information Architecture, Figma",
                "bullets": [
                    "Identified prescription error vectors through contextual inquiry, driving redesign that cut order clicks by 35%.",
                ],
            }
        ],
        "target_job": {
            "title": "Senior UX Researcher",
            "description": "Looking for a dedicated UX Researcher experienced in User Research, Usability Testing, Information Architecture, and User Flows. Experience with Figma, Wireframing, Prototyping, and UI/UX Design principles is required.",
        },
    },

    # -------------------------------------------------------------
    # FIELD 12: Mechanical Engineering & Robotics
    # -------------------------------------------------------------
    {
        "field_id": "mechanical_engineering",
        "field_name": "Mechanical Engineering & Robotics",
        "position_id": "mechanical_design_engineer",
        "position_title": "Mechanical Design Engineer",
        "filename": "12_mechanical_design_engineer.pdf",
        "candidate": {
            "name": "Henrik Larson",
            "email": "henrik.larson@precisionmech.com",
            "phone": "(555) 482-1130",
            "location": "Detroit, MI",
            "linkedin": "linkedin.com/in/henrik-larson-mech",
            "github": "github.com/hlarson-cad",
        },
        "summary": "Mechanical Design Engineer with 5+ years experience in precision CAD modeling, finite element stress analysis (FEA), thermal management, and precision CNC manufacturing under ASME Y14.5 GD&T standards.",
        "education": [
            {
                "degree": "B.S. in Mechanical Engineering",
                "institution": "Purdue University",
                "year": "2020",
                "details": "Focus on Solid Mechanics & Thermal Systems. FE/EIT Certified.",
            }
        ],
        "skills": {
            "CAD & Modeling": "SolidWorks, CAD, 3D Modeling",
            "Simulation & Analysis": "Finite Element Analysis (FEA), Thermodynamics, Structural Analysis",
            "Drafting & Manufacturing": "GD&T, CNC Machining, Tolerance Stack-Up",
            "Materials & Testing": "Rapid Prototyping, Materials Selection, Quality Inspection",
            "Coding & Automation": "Python, MATLAB",
        },
        "experience": [
            {
                "role": "Senior Mechanical Engineer",
                "company": "Vanguard Precision Dynamics",
                "period": "2022 — Present",
                "bullets": [
                    "Designed precision electro-mechanical enclosures and aluminum die-cast housings in SolidWorks and CAD.",
                    "Executed static structural and thermal Finite Element Analysis (FEA) reducing enclosure weight by 22%.",
                    "Applied ASME Y14.5 GD&T standard geometric tolerancing and performed rigorous tolerance stack-up analysis.",
                    "Coordinated with suppliers on CNC Machining tooling, DFM reviews, and first-article coordinate inspections.",
                ],
            },
            {
                "role": "Mechanical Engineer",
                "company": "Apex Powertrain Systems",
                "period": "2020 — 2022",
                "bullets": [
                    "Conducted thermodynamics heat transfer simulations for fluid cooling manifolds in automotive batteries.",
                    "Generated detailed 2D production drawings and rapid 3D prototyping models for functional bench testing.",
                ],
            },
        ],
        "projects": [
            {
                "name": "High-Efficiency Liquid Cold Plate for EV Power Inverter",
                "technologies": "SolidWorks, CAD, Finite Element Analysis (FEA), Thermodynamics",
                "bullets": [
                    "Optimized micro-channel fluid flow path achieving 18% lower thermal resistance under peak load.",
                ],
            }
        ],
        "target_job": {
            "title": "Mechanical Design Engineer",
            "description": "Seeking an experienced Mechanical Engineer skilled in SolidWorks, CAD, Finite Element Analysis (FEA), and Thermodynamics. Must possess deep expertise in GD&T drafting, CNC Machining, and design for manufacturing.",
        },
    },
    {
        "field_id": "mechanical_engineering",
        "field_name": "Mechanical Engineering & Robotics",
        "position_id": "robotics_automation_engineer",
        "position_title": "Robotics & Automation Engineer",
        "filename": "12_mechanical_robotics_engineer.pdf",
        "candidate": {
            "name": "Ananya Sharma",
            "email": "ananya.sharma@robotixlab.org",
            "phone": "(555) 931-6674",
            "location": "Pittsburgh, PA",
            "linkedin": "linkedin.com/in/ananya-sharma-robotics",
            "github": "github.com/asharma-robotics",
        },
        "summary": "Robotics and Automation Engineer specializing in autonomous mobile robotics (AMR), ROS/ROS2 node architectures, embedded real-time firmware in C/C++, and industrial PLC programming.",
        "education": [
            {
                "degree": "M.S. in Robotics Systems",
                "institution": "Carnegie Mellon University",
                "year": "2021",
                "details": "B.S. in Mechatronics from Penn State University (2019).",
            }
        ],
        "skills": {
            "Robotics & Control": "Robotics, ROS, Control Systems, Computer Vision",
            "Embedded & Code": "Embedded C, Python, C++, Linux",
            "Automation Hardware": "PLC Programming, CAD, SolidWorks",
            "Sensors & Systems": "LiDAR, IMU, Motor Drivers, PID Tuning",
            "Tools & Methods": "Git, Docker, Unit Testing, System Design",
        },
        "experience": [
            {
                "role": "Robotics Software & Automation Engineer",
                "company": "OmniBot Autonomous Systems",
                "period": "2022 — Present",
                "bullets": [
                    "Architected autonomous navigation and SLAM path planning packages on Linux using ROS and Python.",
                    "Programmed industrial PLC programming ladder logic for conveyor robotic arm pick-and-place automation.",
                    "Tuned closed-loop PID control systems and motor kinematics achieving millimeter-grade positioning accuracy.",
                    "Developed bare-metal microcontroller firmware in Embedded C interfacing SPI/I2C sensor suites and LiDAR.",
                ],
            },
            {
                "role": "Mechatronics Engineer",
                "company": "Keystone Industrial Automation",
                "period": "2020 — 2022",
                "bullets": [
                    "Designed custom robotic end-effector tooling in SolidWorks CAD and integrated pneumatic valve banks.",
                    "Configured safety interlocks and fieldbus communications across automated manufacturing cells.",
                ],
            },
        ],
        "projects": [
            {
                "name": "Autonomous Warehouse Navigation Rover",
                "technologies": "Robotics, ROS, Embedded C, Control Systems, Python",
                "bullets": [
                    "Implemented dynamic obstacle avoidance navigating dynamic warehouse aisles at 1.5 m/s speed.",
                ],
            }
        ],
        "target_job": {
            "title": "Robotics & Automation Engineer",
            "description": "Looking for a Robotics Engineer skilled in Robotics, ROS, Embedded C, and Control Systems. Must have hands-on experience with PLC Programming, Python, CAD, and real-time sensor integration.",
        },
    },
]


def create_resume_pdf(data: Dict[str, Any], output_path: str) -> None:
    """
    Renders an ATS-friendly, beautifully structured PDF resume using PyMuPDF.
    Uses clean typographic hierarchy with standard page margins and coordinates.
    """
    doc = fitz.open()
    page = doc.new_page(width=612, height=792)  # Standard Letter size

    candidate = data["candidate"]
    
    # Text buffer
    lines: List[str] = []
    
    # 1. Header
    lines.append(candidate["name"].upper())
    contact_parts = [candidate["email"], candidate["phone"], candidate["location"]]
    if candidate.get("linkedin"):
        contact_parts.append(candidate["linkedin"])
    if candidate.get("github"):
        contact_parts.append(candidate["github"])
    lines.append(" | ".join(contact_parts))
    lines.append("")

    # 2. Professional Summary
    lines.append("PROFESSIONAL SUMMARY")
    lines.append(data["summary"])
    lines.append("")

    # 3. Technical & Domain Skills
    lines.append("CORE SKILLS & TECHNICAL COMPETENCIES")
    for category, skill_list in data["skills"].items():
        lines.append(f"• {category}: {skill_list}")
    lines.append("")

    # 4. Professional Experience
    lines.append("PROFESSIONAL EXPERIENCE")
    for exp in data["experience"]:
        lines.append(f"{exp['role']} — {exp['company']} ({exp['period']})")
        for bullet in exp["bullets"]:
            lines.append(f"• {bullet}")
        lines.append("")

    # 5. Key Projects / Initiatives
    lines.append("KEY PROJECTS & TECHNICAL INITIATIVES")
    for proj in data.get("projects", []):
        tech = f" ({proj['technologies']})" if proj.get("technologies") else ""
        lines.append(f"{proj['name']}{tech}")
        for bullet in proj["bullets"]:
            lines.append(f"• {bullet}")
        lines.append("")

    # 6. Education & Certifications
    lines.append("EDUCATION & CREDENTIALS")
    for edu in data["education"]:
        lines.append(f"{edu['degree']} — {edu['institution']} ({edu['year']})")
        if edu.get("details"):
            lines.append(f"• {edu['details']}")

    full_resume_text = "\n".join(lines)

    # Use insert_textbox with margin rectangle for automatic text flow
    rect = fitz.Rect(40, 40, 572, 752)
    # If text overflows a single page, insert additional page
    remaining = page.insert_textbox(rect, full_resume_text, fontsize=9.2, fontname="helv", lineheight=1.28)

    if remaining < 0:
        # Overflowed, insert second page
        page2 = doc.new_page(width=612, height=792)
        # Calculate roughly what didn't fit and put on page 2
        # Or re-split sections
        overflow_text = full_resume_text[int(len(full_resume_text) * 0.7):]
        page2.insert_textbox(rect, overflow_text, fontsize=9.2, fontname="helv", lineheight=1.28)

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    doc.save(output_path)
    doc.close()


def generate_all_resumes(target_dir: str = "tests/sample_resumes") -> List[str]:
    """Generates all 24 resumes into the target directory and outputs catalog.json."""
    os.makedirs(target_dir, exist_ok=True)
    generated_files = []
    catalog = []

    print(f"\n=======================================================")
    print(f"Generating Test Resumes Across 12 Job Fields (24 Roles)")
    print(f"Destination: {os.path.abspath(target_dir)}")
    print(f"=======================================================\n")

    for item in RESUME_DATABASE:
        filepath = os.path.join(target_dir, item["filename"])
        create_resume_pdf(item, filepath)
        generated_files.append(filepath)

        # Collect catalog item
        catalog.append({
            "field_id": item["field_id"],
            "field_name": item["field_name"],
            "position_id": item["position_id"],
            "position_title": item["position_title"],
            "candidate_name": item["candidate"]["name"],
            "filename": item["filename"],
            "filepath": filepath,
            "target_job": item["target_job"],
        })

        print(f"[OK] [{item['field_name']}] -> {item['position_title']} -> {item['filename']}")

    # Save catalog.json
    catalog_path = os.path.join(target_dir, "catalog.json")
    with open(catalog_path, "w", encoding="utf-8") as f:
        json.dump(catalog, f, indent=2)
    print(f"\n[OK] Generated metadata catalog: {catalog_path}")

    # Also generate default tests/sample_resume.pdf for backwards compatibility
    default_sample_path = "tests/sample_resume.pdf"
    create_resume_pdf(RESUME_DATABASE[0], default_sample_path)
    print(f"[OK] Updated default {default_sample_path} (Ethan Vance - Backend Systems Engineer)\n")

    return generated_files


if __name__ == "__main__":
    # Ensure current working directory is backend root if run from tests/
    base_dir = os.path.dirname(os.path.abspath(__file__))
    backend_root = os.path.abspath(os.path.join(base_dir, ".."))
    os.chdir(backend_root)

    generate_all_resumes()
