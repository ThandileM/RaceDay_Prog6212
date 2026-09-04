# RaceDay- Part1: System Planning and Database
# System Description:
RaceDay is a full-stack web-based event management platform for the South African road running, walking, and cycling community. it allows event Organisers to create and manage events, categories, and participant reslus, while participants can browse upcoming events, enter events, and track their personal performance history.
# User Roles:
- Organiser: can create, edit, and delete events, manage event categories, capture partcipant results, and view all event enrolments.
- Participant: can create an account, browse events, enter an event by selecting a category, view their own enrolments, and track their personal results
# Part 1: Deliverables
- ERD: consists of 6 entities (Users, Events, Catefories, EnrolmentStatus, Enrolment, Results), with primary keys, foreign keys, and cardinality.
- API Endpoint plan: covers Authentication, profile, events, categories, enrolment, and results
- SQL Script: tested and confirmed to rum cleanly on a fresh SQL Server instance via SSMS
# CI/CD
This repository uses GitHub Actions to verify that the folder exists and contain the required ERD, endpoint plan, and SQL script on every push
# Green build screenshot:

# Video Presentation
Unlisted YouTube link walking through the planning documents, ERD decisions, endpoint plan choices, and a live run of the SQL script in SSMS:

AI did assist with brief description of what the assignment needed and helped plan the assignment layout, it helped debugg some conflicting sql tables. 
