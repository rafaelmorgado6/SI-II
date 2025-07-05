from pyswip import Prolog
prolog=Prolog()
prolog.consult("dialog.pl")

while True:
    sentence=input("you: ")
    if sentence == "bye":
        break
    words = sentence.split()
    result=list(prolog.query(f"process_sentence({words})"))
    if result == []:
        print("sorry, no idea")

print("nice to talk to you")