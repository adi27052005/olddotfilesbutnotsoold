contribution = {"In-Class exercises": 12, "Home Assignments": 6, "Quizzes": 8, "In-class lab and lab assignments": 24, "Midsem": 18, "Endsem": 18, "Midsem Lab": 6, "Endsem Lab": 8}
gradeDistribution = {"A": 80, "A-": 72, "B": 64, "B-": 56, "C": 44, "C-": 36, "D": 28, "F": 0}

def fetch_grade(contrib, grade_dist):

    marks = {}
    grade = 0

    for key,value in contrib.items():
        marks[key] = int(input(f"Enter marks for : {key} >> "))
        grade += (marks[key]*(contrib[key]/100))

    for key,value in grade_dist.items():
        if grade >= value:
            return(key)

final_grade = fetch_grade(contribution, gradeDistribution)
print(final_grade)
