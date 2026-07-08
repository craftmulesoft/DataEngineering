from pathlib import Path
from xml.sax.saxutils import escape

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.lib.utils import ImageReader
from reportlab.pdfbase.pdfmetrics import stringWidth
from reportlab.platypus import (
    Flowable,
    Image,
    PageBreak,
    Paragraph,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)


ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets"
OUTPUT = ROOT / "output" / "pdf"
PDF_PATH = OUTPUT / "data-engineering-accelerated-program-course-syllabus.pdf"
LOGO_PATH = ASSETS / "craft-syllabus-logo-full.png"
FALLBACK_LOGO_PATH = ASSETS / "craft-knowledge-logo.png"

PAGE_W, PAGE_H = letter

NAVY = colors.HexColor("#061426")
INK = colors.HexColor("#0f172a")
MUTED = colors.HexColor("#475569")
LIGHT = colors.HexColor("#f8fbff")
LINE = colors.HexColor("#dbe7f4")
BLUE = colors.HexColor("#0284c7")
DEEP_BLUE = colors.HexColor("#075985")
CYAN = colors.HexColor("#22d3ee")
GOLD = colors.HexColor("#facc15")
ORANGE = colors.HexColor("#f59e0b")
GREEN = colors.HexColor("#34d399")
PURPLE = colors.HexColor("#a855f7")


TOOLS = {
    "Python": {
        "mark": "Py",
        "color": "#3776AB",
        "weeks": "Weeks 1 and 4",
        "description": "Primary language for extracting API data, cleaning records, validating pipelines, and automating data engineering tasks.",
    },
    "PostgreSQL": {
        "mark": "PG",
        "color": "#336791",
        "weeks": "Weeks 1 and 2",
        "description": "Relational database used to store source sales data, practice SQL, and understand transactional systems.",
    },
    "Pandas": {
        "mark": "pd",
        "color": "#150458",
        "weeks": "Week 1",
        "description": "Python library for DataFrames, cleaning, validation, transformations, feature engineering, and reports.",
    },
    "SQLAlchemy": {
        "mark": "SA",
        "color": "#d71f00",
        "weeks": "Week 1",
        "description": "Python toolkit that creates database connections and helps pipelines read from relational sources.",
    },
    "psycopg2": {
        "mark": "pg2",
        "color": "#336791",
        "weeks": "Week 1",
        "description": "PostgreSQL driver used by Python code to connect, query, and extract data from PostgreSQL.",
    },
    "Jupyter Notebook": {
        "mark": "Jn",
        "color": "#f37626",
        "weeks": "Week 1",
        "description": "Interactive notebook environment for exploration, profiling, documentation, and small pipeline prototypes.",
    },
    "Requests": {
        "mark": "Rq",
        "color": "#2c7fb8",
        "weeks": "Week 1",
        "description": "Python HTTP library used to call public APIs, manage responses, and feed raw JSON into a pipeline.",
    },
    "JSON": {
        "mark": "{}",
        "color": "#111827",
        "weeks": "Weeks 1 and 4",
        "description": "Common API payload format used for nested records, raw files, transformations, and REST integrations.",
    },
    "SQL": {
        "mark": "SQL",
        "color": "#0284c7",
        "weeks": "Weeks 2 and 3",
        "description": "Core language for querying, joining, aggregating, validating, and designing analytical data models.",
    },
    "Snowflake": {
        "mark": "SF",
        "color": "#29b5e8",
        "weeks": "Weeks 3 and 4",
        "description": "Cloud data warehouse for loading raw data, organizing schemas, querying at scale, and serving marts.",
    },
    "dbt": {
        "mark": "dbt",
        "color": "#ff694b",
        "weeks": "Weeks 3 and 4",
        "description": "Analytics engineering framework for modular SQL models, tests, documentation, lineage, and transformations.",
    },
    "Apache Airflow": {
        "mark": "AF",
        "color": "#017cee",
        "weeks": "Week 4",
        "description": "Workflow orchestrator for DAGs, dependencies, schedules, retries, monitoring, and production pipelines.",
    },
    "GitHub Actions": {
        "mark": "GA",
        "color": "#2088ff",
        "weeks": "Week 4",
        "description": "CI/CD automation for Python checks, dbt validation, pull request workflows, and deployment gates.",
    },
    "Power BI": {
        "mark": "PBI",
        "color": "#f2c811",
        "weeks": "Week 4",
        "description": "Business intelligence platform for dashboards, charts, slicers, publishing, and decision-ready reporting.",
    },
    "REST APIs": {
        "mark": "API",
        "color": "#6ba539",
        "weeks": "Weeks 1 and 4",
        "description": "External data source pattern used to consume live data, work with HTTP responses, and build ingestion jobs.",
    },
    "Git and GitHub": {
        "mark": "Git",
        "color": "#f05032",
        "weeks": "Weeks 3 and 4",
        "description": "Version control and collaboration workflow for dbt projects, code review, branching, and portfolio publishing.",
    },
    "CSV and JSON Files": {
        "mark": "CSV",
        "color": "#22c55e",
        "weeks": "Weeks 1, 3, and 4",
        "description": "Portable file formats for extracts, raw layers, cleaned outputs, exports, and pipeline handoffs.",
    },
}


WEEKS = [
    {
        "kicker": "Week 1",
        "title": "Foundations, Python, and DataFrames",
        "accent": "#0284c7",
        "modules": [
            ("Introduction to Data Engineering", []),
            ("Python for Data Engineers", []),
            ("Pandas", []),
            ("Mini Project 1 - Sales Data Pipeline", []),
        ],
        "projects": [
            {
                "title": "Mini Project 1 - Sales Data Pipeline",
                "summary": "Build a pipeline that extracts sales data from PostgreSQL, cleans and validates it, creates metrics, generates reports, and exports processed outputs.",
                "tasks": [
                    "Extract sales data from PostgreSQL.",
                    "Clean and validate the data.",
                    "Create calculated metrics.",
                    "Generate reports.",
                    "Export processed data.",
                ],
                "tools": ["Python", "PostgreSQL", "Pandas", "SQLAlchemy", "psycopg2", "Jupyter Notebook"],
            },
            {
                "title": "Mini Project 2 - Weather Data Pipeline",
                "summary": "Build a complete ETL pipeline that extracts weather data from a public API, transforms it in Pandas, and saves polished analytical outputs.",
                "tasks": [
                    "Extract data from a public API.",
                    "Load data into a Pandas DataFrame.",
                    "Clean and validate the data.",
                    "Perform transformations and feature engineering.",
                    "Generate summary statistics.",
                    "Filter and sort records.",
                    "Save cleaned data into CSV and JSON.",
                    "Produce a simple analytical report.",
                ],
                "tools": ["Python", "Jupyter Notebook", "Pandas", "Requests", "JSON", "CSV and JSON Files"],
            },
        ],
        "tools": ["Python", "PostgreSQL", "Pandas", "SQLAlchemy", "psycopg2", "Jupyter Notebook", "Requests", "JSON"],
    },
    {
        "kicker": "Week 2",
        "title": "Relational Design, SQL, and Warehousing",
        "accent": "#f59e0b",
        "modules": [
            (
                "Database Design - RDBMS",
                [
                    "What is RDBMS?",
                    "SQL databases",
                    "SQL DDL statements",
                    "SQL DML statements",
                    "SQL DQL statements",
                    "SQL constraints",
                    "SQL primary keys",
                    "SQL foreign keys",
                    "SQL composite keys",
                    "SQL alternative keys",
                    "Data integrity",
                ],
            ),
            (
                "Advanced SQL Concepts",
                [
                    "What is JOIN?",
                    "Types of SQL JOIN",
                    "SQL aggregate functions",
                    "LIKE operator",
                    "IN operator",
                    "BETWEEN operator",
                    "UNION",
                    "GROUP BY",
                    "ORDER BY",
                    "HAVING",
                    "EXISTS",
                    "ALL and ANY",
                    "Window functions",
                ],
            ),
            (
                "Dimension Modeling",
                [
                    "What is dimensional modeling?",
                    "Fact tables",
                    "Dimension tables",
                    "Dimension keys",
                    "Slowly changing dimensions",
                    "Flat schema",
                    "Star schema",
                    "Snowflake schema",
                    "Galaxy schema",
                    "CTEs",
                ],
            ),
            (
                "Cardinality and Normalization",
                [
                    "What is normalization?",
                    "Unnormalized form",
                    "First normal form",
                    "Second normal form",
                    "Third normal form",
                    "Boyce-Codd normal form",
                    "Fourth normal form",
                    "Fifth normal form",
                    "Sixth normal form",
                    "Cardinality",
                    "Types of cardinality",
                    "Index",
                    "View",
                ],
            ),
        ],
        "projects": [
            {
                "title": "Mini Project - Sales Data Warehouse",
                "summary": "Design a warehouse that turns normalized sales data into reporting-ready dimensional models and analytics outputs.",
                "groups": [
                    ("Data Modeling", ["OLTP vs OLAP", "Normalized models", "Dimensional modeling"]),
                    ("Data Warehousing", ["Fact tables", "Dimension tables", "Star schema design"]),
                    ("ETL / ELT", ["Extract data", "Transform data", "Load data"]),
                    ("SQL Engineering", ["Joins", "Aggregations", "Window functions", "CTEs", "Data validation queries"]),
                    ("Analytics Engineering", ["Revenue reporting", "Customer analytics", "Product analytics", "Store performance analysis"]),
                    ("Best Practices", ["Surrogate keys", "Data quality checks", "Performance tuning", "Scalable warehouse design"]),
                ],
                "tools": ["SQL", "PostgreSQL"],
            }
        ],
        "tools": ["SQL", "PostgreSQL"],
    },
    {
        "kicker": "Week 3",
        "title": "Cloud Data Warehousing and Transformation",
        "accent": "#a855f7",
        "modules": [
            (
                "Cloud Data Warehousing",
                [
                    "What is a cloud data platform?",
                    "Components of a cloud data platform",
                    "The cloud data landscape",
                    "What is a data warehouse?",
                    "ETL",
                    "ELT",
                    "ETL vs ELT",
                ],
            ),
            (
                "Snowflake",
                [
                    "What is Snowflake?",
                    "Why Snowflake?",
                    "Snowflake architecture",
                    "Snowflake editions",
                    "Virtual warehouses",
                    "Snowflake Marketplace",
                    "RBAC",
                    "Loading data",
                    "COPY INTO",
                    "Snowpipe",
                    "Databases and schemas",
                    "Tables",
                    "Time Travel",
                ],
            ),
            (
                "dbt",
                [
                    "What is dbt?",
                    "dbt architecture",
                    "dbt in the modern data stack",
                    "Installing dbt",
                    "dbt project structure",
                    "Layered modeling",
                    "Choosing models",
                    "Jinja in dbt",
                    "Model selection",
                    "Running dbt",
                    "dbt testing",
                    "Documentation",
                    "dbt Core vs dbt Cloud",
                ],
            ),
        ],
        "projects": [
            {
                "title": "Sales Data Warehousing and Transformation",
                "summary": "Load raw CSV files into Snowflake, organize schemas, build dbt models, test quality, document lineage, and publish the project to GitHub.",
                "tasks": [
                    "Load raw CSV files into Snowflake.",
                    "Organize data into schemas.",
                    "Build staging models using dbt.",
                    "Build intermediate models.",
                    "Build mart models.",
                    "Test data quality.",
                    "Document the project.",
                    "Track changes using Git.",
                    "Publish the project to GitHub.",
                ],
                "tools": ["Snowflake", "dbt", "SQL", "Git and GitHub", "CSV and JSON Files"],
            }
        ],
        "tools": ["Snowflake", "dbt", "SQL", "Git and GitHub", "CSV and JSON Files"],
    },
    {
        "kicker": "Week 4",
        "title": "Orchestration, CI/CD, BI, and Capstone Delivery",
        "accent": "#22c55e",
        "modules": [
            (
                "Apache Airflow",
                [
                    "What is Apache Airflow?",
                    "Airflow architecture",
                    "Core components",
                    "What is a DAG?",
                    "Task",
                    "Task dependencies",
                    "Executors",
                    "Alerting and notifications",
                    "Scheduling",
                    "Cron expression",
                    "Airflow folder structure",
                    "Monitoring and logging",
                    "Airflow vs other tools",
                ],
            ),
            (
                "CI/CD for Data Projects with GitHub Actions",
                [
                    "What is CI/CD?",
                    "Continuous integration",
                    "Continuous delivery",
                    "CI/CD tools",
                    "What is GitHub Actions?",
                    "GitHub Actions components",
                    "Python CI workflow",
                    "CI pipeline for dbt",
                    "GitHub Actions for Snowflake",
                    "GitHub Actions for Apache Airflow",
                    "GitHub Actions pipeline for Airflow",
                    "Code quality checks",
                    "Branching strategy",
                    "Pull request workflow",
                    "Data engineering CI/CD pipeline",
                ],
            ),
            (
                "Business Analysis - Power BI",
                [
                    "What is business intelligence?",
                    "Power BI",
                    "Power BI architecture",
                    "Visualizations",
                    "Common charts",
                    "Uncommon charts",
                    "Filters",
                    "Slicers",
                    "Getting data in Power BI",
                    "Publish",
                    "Power BI workspace",
                ],
            ),
        ],
        "projects": [
            {
                "title": "Capstone Project 1 - API to Dashboard Platform",
                "summary": "Build an end-to-end modern data platform from REST APIs through Snowflake, dbt, Airflow, GitHub Actions, and Power BI.",
                "tasks": [
                    "Extract data from REST APIs using Python.",
                    "Store and manage raw datasets following data lake principles.",
                    "Load and query data efficiently in Snowflake.",
                    "Build modular, testable transformation pipelines with dbt.",
                    "Design and schedule end-to-end workflows using Apache Airflow.",
                    "Create optimized reporting tables for analytics.",
                    "Develop professional Power BI dashboards with actionable insights.",
                    "Implement CI/CD automation using GitHub Actions.",
                    "Apply layered architectures using Raw/Bronze, Silver, and Gold data zones.",
                    "Use version control, testing, and documentation as delivery standards.",
                ],
                "tools": ["REST APIs", "Python", "Snowflake", "dbt", "Apache Airflow", "GitHub Actions", "Power BI"],
            },
            {
                "title": "Capstone Project 2 - Complete Analytics Warehouse",
                "summary": "Consume APIs, work with JSON, design Snowflake databases, transform data with dbt, schedule Airflow pipelines, and publish BI dashboards.",
                "tasks": [
                    "Consume REST APIs.",
                    "Work with JSON data.",
                    "Build ETL/ELT pipelines.",
                    "Design Snowflake databases.",
                    "Transform data using dbt.",
                    "Build star schemas.",
                    "Create fact and dimension tables.",
                    "Schedule pipelines with Airflow.",
                    "Build Power BI dashboards.",
                    "Implement CI/CD using GitHub Actions.",
                ],
                "tools": ["REST APIs", "JSON", "Snowflake", "dbt", "Apache Airflow", "Power BI", "GitHub Actions"],
            },
        ],
        "tools": ["Apache Airflow", "GitHub Actions", "Power BI", "REST APIs", "Python", "JSON", "Snowflake", "dbt"],
    },
]


def h(value):
    return colors.HexColor(value)


def para(text, style):
    return Paragraph(escape(text), style)


def rich(text, style):
    return Paragraph(text, style)


def wrap_canvas_text(canvas, text, font_name, font_size, max_width, max_lines):
    words = text.split()
    lines = []
    current = ""
    for word in words:
        trial = word if not current else f"{current} {word}"
        if stringWidth(trial, font_name, font_size) <= max_width:
            current = trial
        else:
            if current:
                lines.append(current)
            current = word
        if len(lines) == max_lines:
            break
    if len(lines) < max_lines and current:
        lines.append(current)
    if len(lines) > max_lines:
        lines = lines[:max_lines]
    if len(lines) == max_lines:
        used = " ".join(lines)
        if len(used) < len(text):
            lines[-1] = lines[-1].rstrip(".") + "..."
    return lines


class ToolCard(Flowable):
    def __init__(self, name, data, height=86):
        super().__init__()
        self.name = name
        self.data = data
        self.height = height
        self.width = 240

    def wrap(self, avail_width, avail_height):
        self.width = avail_width
        return avail_width, self.height

    def draw(self):
        c = self.canv
        w = self.width
        ht = self.height
        accent = h(self.data["color"])
        c.saveState()
        c.setFillColor(colors.white)
        c.setStrokeColor(colors.Color(accent.red, accent.green, accent.blue, alpha=0.38))
        c.setLineWidth(1)
        c.roundRect(0, 0, w, ht, 8, stroke=1, fill=1)
        c.setFillColor(colors.Color(accent.red, accent.green, accent.blue, alpha=0.08))
        c.roundRect(4, 4, w - 8, ht - 8, 6, stroke=0, fill=1)
        c.setFillColor(accent)
        c.circle(28, ht - 31, 18, stroke=0, fill=1)
        c.setFillColor(INK if self.data["color"].lower() in {"#f2c811", "#facc15"} else colors.white)
        c.setFont("Helvetica-Bold", 8.5 if len(self.data["mark"]) > 2 else 11)
        c.drawCentredString(28, ht - 35, self.data["mark"])
        c.setFillColor(INK)
        c.setFont("Helvetica-Bold", 10.5)
        c.drawString(56, ht - 22, self.name)
        c.setFillColor(MUTED)
        c.setFont("Helvetica", 7.7)
        y = ht - 37
        for line in wrap_canvas_text(c, self.data["description"], "Helvetica", 7.7, w - 68, 3):
            c.drawString(56, y, line)
            y -= 9.5
        c.setFillColor(colors.Color(accent.red, accent.green, accent.blue, alpha=0.14))
        c.roundRect(56, 9, min(w - 68, 112), 14, 7, stroke=0, fill=1)
        c.setFillColor(DEEP_BLUE)
        c.setFont("Helvetica-Bold", 6.8)
        c.drawString(64, 13, self.data["weeks"])
        c.restoreState()


class ToolPill(Flowable):
    def __init__(self, name, data, height=30):
        super().__init__()
        self.name = name
        self.data = data
        self.height = height
        self.width = 120

    def wrap(self, avail_width, avail_height):
        self.width = avail_width
        return avail_width, self.height

    def draw(self):
        c = self.canv
        w = self.width
        ht = self.height
        accent = h(self.data["color"])
        c.saveState()
        c.setFillColor(colors.white)
        c.setStrokeColor(colors.Color(accent.red, accent.green, accent.blue, alpha=0.42))
        c.roundRect(0, 0, w, ht, 8, stroke=1, fill=1)
        c.setFillColor(colors.Color(accent.red, accent.green, accent.blue, alpha=0.14))
        c.roundRect(4, 4, w - 8, ht - 8, 6, stroke=0, fill=1)
        c.setFillColor(accent)
        c.circle(17, ht / 2, 9, stroke=0, fill=1)
        c.setFillColor(INK if self.data["color"].lower() in {"#f2c811", "#facc15"} else colors.white)
        c.setFont("Helvetica-Bold", 5.8 if len(self.data["mark"]) > 2 else 7)
        c.drawCentredString(17, ht / 2 - 2.2, self.data["mark"])
        c.setFillColor(INK)
        c.setFont("Helvetica-Bold", 7.2)
        label = self.name if len(self.name) <= 17 else self.name[:15] + "..."
        c.drawString(31, ht / 2 - 2.6, label)
        c.restoreState()


class WeekRibbon(Flowable):
    def __init__(self, week, title, accent):
        super().__init__()
        self.week = week
        self.title = title
        self.accent = h(accent)
        self.width = 520
        self.height = 58

    def wrap(self, avail_width, avail_height):
        self.width = avail_width
        return avail_width, self.height

    def draw(self):
        c = self.canv
        w = self.width
        c.saveState()
        c.setFillColor(colors.white)
        c.setStrokeColor(colors.Color(self.accent.red, self.accent.green, self.accent.blue, alpha=0.36))
        c.roundRect(0, 0, w, self.height, 8, stroke=1, fill=1)
        c.setFillColor(self.accent)
        c.roundRect(0, 0, 96, self.height, 8, stroke=0, fill=1)
        c.setFillColor(colors.white)
        c.setFont("Helvetica-Bold", 16)
        c.drawCentredString(48, 34, self.week)
        c.setFont("Helvetica", 8)
        c.drawCentredString(48, 20, "weekly course syllabus")
        c.setFillColor(INK)
        c.setFont("Helvetica-Bold", 18)
        c.drawString(114, 33, self.title)
        c.setFillColor(MUTED)
        c.setFont("Helvetica", 8.5)
        c.drawString(114, 18, "Course modules, project outcomes, and technologies used")
        c.restoreState()


class FlowBand(Flowable):
    def __init__(self):
        super().__init__()
        self.width = 520
        self.height = 94

    def wrap(self, avail_width, avail_height):
        self.width = avail_width
        return avail_width, self.height

    def draw(self):
        c = self.canv
        w = self.width
        c.saveState()
        c.setStrokeColor(colors.HexColor("#dbe7f4"))
        c.setLineWidth(1)
        c.roundRect(0, 0, w, self.height, 8, stroke=1, fill=0)
        steps = [
            ("Extract", BLUE),
            ("Store", CYAN),
            ("Model", ORANGE),
            ("Orchestrate", GREEN),
            ("Dashboard", GOLD),
        ]
        gap = 12
        box_w = (w - gap * (len(steps) - 1) - 24) / len(steps)
        y = 27
        for i, (label, color) in enumerate(steps):
            x = 12 + i * (box_w + gap)
            c.setFillColor(colors.Color(color.red, color.green, color.blue, alpha=0.14))
            c.setStrokeColor(colors.Color(color.red, color.green, color.blue, alpha=0.5))
            c.roundRect(x, y, box_w, 36, 8, stroke=1, fill=1)
            c.setFillColor(color)
            c.circle(x + 16, y + 18, 6, stroke=0, fill=1)
            c.setFillColor(INK)
            c.setFont("Helvetica-Bold", 8.2)
            c.drawString(x + 28, y + 15, label)
            if i < len(steps) - 1:
                c.setStrokeColor(colors.HexColor("#94a3b8"))
                c.line(x + box_w + 2, y + 18, x + box_w + gap - 2, y + 18)
        c.setFillColor(MUTED)
        c.setFont("Helvetica", 8)
        c.drawString(14, 11, "Capstone pattern: API/Python -> raw data -> Snowflake/dbt -> Airflow/GitHub Actions -> Power BI")
        c.restoreState()


def build_styles():
    base = getSampleStyleSheet()
    return {
        "CoverTitle": ParagraphStyle(
            "CoverTitle",
            parent=base["Title"],
            fontName="Helvetica-Bold",
            fontSize=27,
            leading=31,
            textColor=INK,
            alignment=TA_LEFT,
            spaceAfter=10,
        ),
        "CoverSub": ParagraphStyle(
            "CoverSub",
            parent=base["BodyText"],
            fontName="Helvetica",
            fontSize=11,
            leading=16,
            textColor=MUTED,
            spaceAfter=10,
        ),
        "Kicker": ParagraphStyle(
            "Kicker",
            parent=base["BodyText"],
            fontName="Helvetica-Bold",
            fontSize=8,
            leading=10,
            textColor=DEEP_BLUE,
            uppercase=True,
            spaceAfter=4,
        ),
        "H1": ParagraphStyle(
            "H1",
            parent=base["Heading1"],
            fontName="Helvetica-Bold",
            fontSize=20,
            leading=24,
            textColor=INK,
            spaceBefore=4,
            spaceAfter=8,
        ),
        "H2": ParagraphStyle(
            "H2",
            parent=base["Heading2"],
            fontName="Helvetica-Bold",
            fontSize=12.5,
            leading=15,
            textColor=INK,
            spaceBefore=4,
            spaceAfter=5,
        ),
        "Body": ParagraphStyle(
            "Body",
            parent=base["BodyText"],
            fontName="Helvetica",
            fontSize=9.2,
            leading=12.5,
            textColor=MUTED,
            spaceAfter=5,
        ),
        "Small": ParagraphStyle(
            "Small",
            parent=base["BodyText"],
            fontName="Helvetica",
            fontSize=7.9,
            leading=10.5,
            textColor=MUTED,
            spaceAfter=3,
        ),
        "Bullet": ParagraphStyle(
            "Bullet",
            parent=base["BodyText"],
            fontName="Helvetica",
            fontSize=8.3,
            leading=10.7,
            leftIndent=8,
            firstLineIndent=-8,
            textColor=MUTED,
            spaceAfter=2.2,
        ),
        "CardTitle": ParagraphStyle(
            "CardTitle",
            parent=base["BodyText"],
            fontName="Helvetica-Bold",
            fontSize=10.7,
            leading=13,
            textColor=INK,
            spaceAfter=4,
        ),
        "CardSub": ParagraphStyle(
            "CardSub",
            parent=base["BodyText"],
            fontName="Helvetica",
            fontSize=8.4,
            leading=11,
            textColor=MUTED,
            spaceAfter=4,
        ),
        "CenterSmall": ParagraphStyle(
            "CenterSmall",
            parent=base["BodyText"],
            fontName="Helvetica-Bold",
            fontSize=8,
            leading=10,
            textColor=INK,
            alignment=TA_CENTER,
        ),
    }


STYLES = build_styles()


def card(content, accent="#0284c7", padding=8):
    bg = colors.white
    accent_color = h(accent)
    table = Table([[content]], colWidths=[None])
    table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, -1), bg),
                ("BOX", (0, 0), (-1, -1), 0.75, colors.Color(accent_color.red, accent_color.green, accent_color.blue, alpha=0.35)),
                ("LEFTPADDING", (0, 0), (-1, -1), padding),
                ("RIGHTPADDING", (0, 0), (-1, -1), padding),
                ("TOPPADDING", (0, 0), (-1, -1), padding),
                ("BOTTOMPADDING", (0, 0), (-1, -1), padding),
            ]
        )
    )
    return table


def bullet_items(items, style=None):
    style = style or STYLES["Bullet"]
    return [para(f"- {item}", style) for item in items]


def module_block(title, topics, accent):
    content = [rich(f"<font color='{accent}'><b>{escape(title)}</b></font>", STYLES["CardTitle"])]
    if topics:
        content.extend(bullet_items(topics))
    else:
        content.append(para("Core concepts, examples, and guided practice.", STYLES["CardSub"]))
    return card(content, accent=accent, padding=7)


def project_block(project, accent):
    content = [
        rich(f"<font color='{accent}'><b>{escape(project['title'])}</b></font>", STYLES["CardTitle"]),
        para(project["summary"], STYLES["CardSub"]),
    ]
    if "tasks" in project:
        content.extend(bullet_items(project["tasks"]))
    if "groups" in project:
        for group, items in project["groups"]:
            content.append(rich(f"<b>{escape(group)}</b>", STYLES["Small"]))
            content.extend(bullet_items(items, STYLES["Small"]))
    tools = ", ".join(project.get("tools", []))
    if tools:
        content.append(rich(f"<b>Technologies used:</b> {escape(tools)}", STYLES["Small"]))
    return card(content, accent=accent, padding=8)


def tool_cards(names):
    rows = []
    for i in range(0, len(names), 2):
        left = ToolCard(names[i], TOOLS[names[i]])
        right = ToolCard(names[i + 1], TOOLS[names[i + 1]]) if i + 1 < len(names) else ""
        rows.append([left, right])
    table = Table(rows, colWidths=[252, 252], hAlign="LEFT")
    table.setStyle(
        TableStyle(
            [
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("LEFTPADDING", (0, 0), (-1, -1), 0),
                ("RIGHTPADDING", (0, 0), (-1, -1), 8),
                ("TOPPADDING", (0, 0), (-1, -1), 4),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
            ]
        )
    )
    return table


def tool_pills(names):
    rows = []
    cols = 4
    col_width = 126
    for i in range(0, len(names), cols):
        row = []
        for name in names[i : i + cols]:
            row.append(ToolPill(name, TOOLS[name]))
        while len(row) < cols:
            row.append("")
        rows.append(row)
    table = Table(rows, colWidths=[col_width] * cols, hAlign="LEFT")
    table.setStyle(
        TableStyle(
            [
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("LEFTPADDING", (0, 0), (-1, -1), 0),
                ("RIGHTPADDING", (0, 0), (-1, -1), 4),
                ("TOPPADDING", (0, 0), (-1, -1), 2),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
            ]
        )
    )
    return table


def module_grid(modules, accent):
    rows = []
    for i in range(0, len(modules), 2):
        left = module_block(modules[i][0], modules[i][1], accent)
        right = module_block(modules[i + 1][0], modules[i + 1][1], accent) if i + 1 < len(modules) else ""
        rows.append([left, right])
    table = Table(rows, colWidths=[252, 252], hAlign="LEFT")
    table.setStyle(
        TableStyle(
            [
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("LEFTPADDING", (0, 0), (-1, -1), 0),
                ("RIGHTPADDING", (0, 0), (-1, -1), 8),
                ("TOPPADDING", (0, 0), (-1, -1), 4),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
            ]
        )
    )
    return table


def project_grid(projects, accent):
    rows = [[project_block(project, accent)] for project in projects]
    table = Table(rows, colWidths=[512], hAlign="LEFT")
    table.setStyle(
        TableStyle(
            [
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("LEFTPADDING", (0, 0), (-1, -1), 0),
                ("RIGHTPADDING", (0, 0), (-1, -1), 0),
                ("TOPPADDING", (0, 0), (-1, -1), 3),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
            ]
        )
    )
    return table


def snapshot_table():
    cells = []
    for title, value, color in [
        ("Duration", "4 weeks", "#0284c7"),
        ("Portfolio", "5 projects", "#f59e0b"),
        ("Outcome", "Capstone platform", "#22c55e"),
    ]:
        cells.append(
            [
                rich(f"<font color='{color}'><b>{escape(title)}</b></font>", STYLES["CenterSmall"]),
                rich(f"<font size='15'><b>{escape(value)}</b></font>", STYLES["CenterSmall"]),
            ]
        )
    table = Table([cells], colWidths=[164, 164, 164], hAlign="LEFT")
    table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, -1), colors.white),
                ("BOX", (0, 0), (-1, -1), 0.75, LINE),
                ("INNERGRID", (0, 0), (-1, -1), 0.5, LINE),
                ("LEFTPADDING", (0, 0), (-1, -1), 8),
                ("RIGHTPADDING", (0, 0), (-1, -1), 8),
                ("TOPPADDING", (0, 0), (-1, -1), 9),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 9),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
            ]
        )
    )
    return table


def week_story(week):
    accent = week["accent"]
    story = [
        WeekRibbon(week["kicker"], week["title"], accent),
        Spacer(1, 10),
        rich("<b>Weekly course syllabus</b>", STYLES["Kicker"]),
        para("Modules and practice are sequenced so each week produces a portfolio artifact and supports the final capstone.", STYLES["Body"]),
        Spacer(1, 5),
        module_grid(week["modules"], accent),
        Spacer(1, 4),
        rich("<b>Visual tool stack for this week</b>", STYLES["H2"]),
        tool_pills(week["tools"]),
        Spacer(1, 4),
        rich("<b>Project work</b>", STYLES["H2"]),
        project_grid(week["projects"], accent),
    ]
    if week["kicker"] == "Week 4":
        story.insert(3, FlowBand())
        story.insert(4, Spacer(1, 8))
    return story


def draw_logo(canvas, x, y, max_w, max_h):
    logo = LOGO_PATH if LOGO_PATH.exists() else FALLBACK_LOGO_PATH
    if not logo.exists():
        return
    reader = ImageReader(str(logo))
    iw, ih = reader.getSize()
    scale = min(max_w / iw, max_h / ih)
    w = iw * scale
    hgt = ih * scale
    canvas.drawImage(reader, x, y + (max_h - hgt) / 2, width=w, height=hgt, preserveAspectRatio=True, mask="auto")


def on_page(canvas, doc):
    page = canvas.getPageNumber()
    canvas.saveState()
    canvas.setFillColor(LIGHT)
    canvas.rect(0, 0, PAGE_W, PAGE_H, stroke=0, fill=1)
    canvas.setFillColor(colors.Color(BLUE.red, BLUE.green, BLUE.blue, alpha=0.06))
    canvas.circle(PAGE_W - 40, PAGE_H - 32, 160, stroke=0, fill=1)
    canvas.setFillColor(colors.Color(ORANGE.red, ORANGE.green, ORANGE.blue, alpha=0.08))
    canvas.circle(18, 38, 120, stroke=0, fill=1)
    canvas.setFillAlpha(1)
    canvas.setStrokeAlpha(1)

    if page == 1:
        draw_logo(canvas, 42, PAGE_H - 128, 112, 112)
        canvas.setFillColor(INK)
        canvas.setFont("Helvetica-Bold", 15.5)
        canvas.drawString(176, PAGE_H - 64, "Data Engineering Accelerated Program Course Syllabus")
        canvas.setFillColor(DEEP_BLUE)
        canvas.setFont("Helvetica", 8.5)
        canvas.drawString(176, PAGE_H - 81, "Python, SQL, Snowflake, dbt, Airflow, GitHub Actions, and Power BI")
        canvas.setStrokeColor(LINE)
        canvas.line(36, PAGE_H - 124, PAGE_W - 36, PAGE_H - 124)
    else:
        draw_logo(canvas, 38, PAGE_H - 68, 52, 52)
        canvas.setFillColor(INK)
        canvas.setFont("Helvetica-Bold", 9)
        canvas.drawString(104, PAGE_H - 37, "Data Engineering Accelerated Program Course Syllabus")
        canvas.setFillColor(DEEP_BLUE)
        canvas.setFont("Helvetica", 8)
        canvas.drawString(104, PAGE_H - 49, "Weekly course syllabus and tool reference")
        canvas.setStrokeColor(LINE)
        canvas.line(36, PAGE_H - 66, PAGE_W - 36, PAGE_H - 66)

    canvas.setStrokeColor(LINE)
    canvas.line(36, 34, PAGE_W - 36, 34)
    canvas.setFillColor(MUTED)
    canvas.setFont("Helvetica", 7.5)
    canvas.drawString(36, 20, "Craft Knowledge - Modern data engineering portfolio program")
    canvas.drawRightString(PAGE_W - 36, 20, f"Page {page}")
    canvas.restoreState()


def cover_story():
    rows = [
        [
            rich("<font color='#0284c7'><b>Week 1</b></font><br/>Python, Pandas, APIs, PostgreSQL", STYLES["Small"]),
            rich("<font color='#f59e0b'><b>Week 2</b></font><br/>RDBMS, SQL, modeling, warehouse design", STYLES["Small"]),
            rich("<font color='#a855f7'><b>Week 3</b></font><br/>Snowflake, dbt, ELT, transformation", STYLES["Small"]),
            rich("<font color='#22c55e'><b>Week 4</b></font><br/>Airflow, CI/CD, Power BI, capstone", STYLES["Small"]),
        ]
    ]
    timeline = Table(rows, colWidths=[123, 123, 123, 123], hAlign="LEFT")
    timeline.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, -1), colors.white),
                ("BOX", (0, 0), (-1, -1), 0.75, LINE),
                ("INNERGRID", (0, 0), (-1, -1), 0.5, LINE),
                ("LEFTPADDING", (0, 0), (-1, -1), 7),
                ("RIGHTPADDING", (0, 0), (-1, -1), 7),
                ("TOPPADDING", (0, 0), (-1, -1), 8),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
            ]
        )
    )
    return [
        Spacer(1, 94),
        rich("Data Engineering Accelerated Program Course Syllabus", STYLES["CoverTitle"]),
        para(
            "A practical four-week program for building production-style data pipelines, cloud warehouses, transformations, orchestration, CI/CD automation, and BI dashboards.",
            STYLES["CoverSub"],
        ),
        snapshot_table(),
        Spacer(1, 14),
        FlowBand(),
        Spacer(1, 14),
        rich("<b>Program rhythm</b>", STYLES["H2"]),
        timeline,
        Spacer(1, 14),
        rich("<b>What learners build</b>", STYLES["H2"]),
        card(
            bullet_items(
                [
                    "Sales and weather data pipelines with clean exports and analytical reports.",
                    "A dimensional sales data warehouse with validation queries and performance-aware design.",
                    "Snowflake and dbt transformation layers with tests, documentation, and Git publishing.",
                    "End-to-end capstone pipelines scheduled in Airflow and delivered through Power BI.",
                ]
            ),
            accent="#0284c7",
        ),
    ]


def tool_glossary_story():
    names = list(TOOLS.keys())
    return [
        PageBreak(),
        rich("<b>Tool Glossary</b>", STYLES["Kicker"]),
        rich("Visual guide to the program tool stack.", STYLES["H1"]),
        para(
            "Each tool appears with a compact visual badge, where it fits in the course, and the practical job it performs in the data engineering workflow.",
            STYLES["Body"],
        ),
        tool_cards(names),
    ]


def build_pdf():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    doc = SimpleDocTemplate(
        str(PDF_PATH),
        pagesize=letter,
        leftMargin=40,
        rightMargin=40,
        topMargin=82,
        bottomMargin=46,
        title="Data Engineering Accelerated Program Course Syllabus",
        author="Craft Knowledge",
        subject="Course syllabus for a data engineering accelerated program",
    )
    story = []
    story.extend(cover_story())
    for week in WEEKS:
        story.append(PageBreak())
        story.extend(week_story(week))
    story.extend(tool_glossary_story())
    doc.build(story, onFirstPage=on_page, onLaterPages=on_page)
    return PDF_PATH


if __name__ == "__main__":
    path = build_pdf()
    print(path)
