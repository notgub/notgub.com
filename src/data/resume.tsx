import { Icons } from "@/components/icons";
import { HomeIcon, NotebookIcon } from "lucide-react";

export const DATA = {
  name: "Chanchai Thaiyanon",
  initials: "CT",
  title: "notgub.com",
  url: "https://notgub.com",
  location: "Chiang Mai, TH",
  locationLink: "https://www.google.com/maps/place/Chiang+Mai",
  description:
    "Senior Software Engineer with 8+ years of experience delivering cloud-native, full-stack, and embedded solutions across HR and manufacturing industries. Specialized in .NET, AWS, and embedded systems.",
  summary:
    "I'm an experienced software engineer specializing in cloud-native enterprise systems and embedded development. Over the past 8+ years, I’ve built and deployed solutions spanning HR, manufacturing, and healthcare domains. I’m passionate about designing scalable backend systems with .NET and AWS, and love experimenting with embedded systems and modern web technologies.",
  avatarUrl: "/me.png",
  skills: [
    "C#",
    ".NET",
    "ASP.NET",
    "AWS",
    "Node.js",
    "React",
    "Next.js",
    "TypeScript",
    "TailwindCSS",
    "SQL",
    "DynamoDB",
    "Docker",
    "Embedded Systems",
    "Python",
    "Go",
  ],
  navbar: [{ href: "/profile", icon: HomeIcon, label: "Home" }],
  contact: {
    email: "chanchai.thaiyanon@gmail.com",
    tel: "+66883132513",
    social: {
      GitHub: {
        name: "GitHub",
        url: "https://github.com/notgub",
        icon: Icons.github,
        navbar: true,
      },
      LinkedIn: {
        name: "LinkedIn",
        url: "https://linkedin.com/in/chanchai-th",
        icon: Icons.linkedin,
        navbar: true,
      },
      Youtube: {
        name: "Youtube",
        url: "https://www.youtube.com/@notgub",
        icon: Icons.youtube,
        navbar: true,
      },
      email: {
        name: "Send Email",
        url: "#",
        icon: Icons.email,
        navbar: false,
      },
    },
  },

  work: [
    {
      company: "Nisshinbo Micro Device (Thailand) Co., Ltd.",
      href: "https://www.nisshinbo-microdevices.co.jp/en/",
      location: "Lamphun, Thailand",
      title: "Senior Software Engineer",
      logoUrl: "/nisshinbo.png",
      start: "February 2024",
      end: "Present",
      badges: [],
      description:
        "Develop desktop and mobile applications from design to delivery, some integrating with hardware. Collaborate with Japanese teams to deliver a cloud-based healthcare solution for Japan. Design embedded hardware (PCB, circuit layout) and develop firmware for hardware devices.",
    },
    {
      company: "Humanica Public Company Ltd.",
      href: "https://www.humanica.com/",
      location: "Bangkok, Thailand",
      title: "Software Developer",
      logoUrl: "/humanica.png",
      start: "November 2020",
      end: "August 2023",
      badges: [],
      description:
        "Developed and maintained enterprise HR and payroll systems for large organizations. Collaborated across design, QA, and operations to ensure high-quality delivery. Led migration of legacy systems to modern cloud-based microservice architectures for improved scalability.",
    },
    {
      company: "Hoya Lamphun Ltd.",
      href: "https://www.hoya.co.th/",
      location: "Lamphun, Thailand",
      title: "IT Engineer",
      logoUrl: "/hoya.png",
      start: "November 2016",
      end: "October 2020",
      badges: [],
      description:
        "Built factory-wide web applications to streamline manufacturing processes. Designed HR systems for leave and overtime tracking. Created image-processing solutions using computer vision to automate quality checks. Researched and deployed GCP services for industrial automation.",
    },
  ],
  education: [
    {
      school: "Khon Kaen University",
      href: "https://kku.ac.th",
      degree: "Bachelor of Engineering in Computer Engineering",
      logoUrl: "/kku.png",
      start: "2012",
      end: "2016",
      description: "Graduated with 2.51 GPA",
    },
  ],

  certifications: [
    {
      title: "AWS Certified Developer - Associate",
      issuer: "Amazon Web Services",
      issued: "June 2025",
      validation: "e17c42fa8fa4434892cfd05c1c9da969",
    },
  ],

  projects: [
    {
      title: "notgub.com",
      href: "https://notgub.com",
      dates: "2025 – Present",
      active: true,
      image: "",
      video: "",
      description:
        "Personal website and portfolio showcasing projects, experience, and blog posts. Built using Next.js, TailwindCSS, and TypeScript.",
      technologies: ["Next.js", "TypeScript", "TailwindCSS", "Vercel"],
      links: [
        {
          type: "Website",
          href: "https://notgub.com",
          icon: <Icons.globe className="size-3" />,
        },
      ],
    },
  ],

  hackathons: [],
} as const;
