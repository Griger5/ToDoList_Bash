#!/bin/bash
 
add() {
    printf "Input the name of your task: "
    read i
    printf "Input the time: "
    read j
    printf "Input the date of the task: "
    read k
    printf "\n$i;$j;$k;" >> .todo_base.txt
}
 
del() {
    printf "Select an entry for deletion\n"
    awk 'BEGIN { FS=";"; i=1 } NF {print i")", $1, $2, $3; i++}' .todo_base.txt
    read delete
    awk -v var=$delete 'NF {if (NR!=var) print $0}' .todo_base.txt > temp && mv temp .todo_base.txt
}
 
edit() {
    printf "Select an entry to edit:\n"
    awk 'BEGIN { FS=";"; i=1 } NF {print i")", $1, $2, $3; i++}' .todo_base.txt
    length=`wc -l .todo_base.txt | tr -d '[:alpha:] [:punct:]'`
 
    while true
    do
        read edit
        if (($edit <= length && $edit > 0))
        then
            printf "What do you want to edit?\n"
            select x in title hour date
            do
                case $x in
                    title) 
                        printf "Enter new info:\n"
                        read edited
                        awk -v line=$edit -v change=$edited 'BEGIN { FS=";" } NF {if (NR!=line) {print $0} else {print change";"$2";"$3";"}}' .todo_base.txt > temp && mv temp .todo_base.txt
                        ;;
                    hour) 
                        printf "Enter new info:\n"
                        read edited
                        awk -v line=$edit -v change=$edited 'BEGIN { FS=";" } NF {if (NR!=line) {print $0} else {print $1";"change";"$3";"}}' .todo_base.txt > temp && mv temp .todo_base.txt
                        ;;
                    date) 
                        printf "Enter new info:\n"
                        read edited
                        awk -v line=$edit -v change=$edited 'BEGIN { FS=";" } NF {if (NR!=line) {print $0} else {print $1";"$2";"change";"}}' .todo_base.txt > temp && mv temp .todo_base.txt
                        ;;
                    *)
                        printf "Not a valid option!\n"
                        continue
                        ;;
                esac
                break
            done
            break
        else
            printf "There's no entry of that number!\n"
            printf "Select an entry to edit:\n"
        fi
    done
}
 
init() {
    if [ -e .todo_exists ]
    then 
        echo "todo was already initialized!"
    else
        echo "alias todo='./.todo.sh';" >> ~/.bashrc
        echo "./.todo.sh;" >> ~/.bashrc
        touch ~/.todo_exists
    fi
}
 
show() {
    echo "Your TODO list:"
    if [ -e .todo_base.txt ]
    then
        awk 'BEGIN { FS=";" } NF {print $1, $2, $3}' .todo_base.txt
    else
        echo "your list is empty!"
    fi
}
 
help() {
    printf "use './.todo.sh init' to initialize the script, now the script will run whenever you log in, and you can run it just by using the command 'todo'\n"
    printf "use 'todo add' to add a new entry to your list\n"
    printf "use 'todo del' to delete an existing entry from your list\n"
    printf "use 'todo edit' to edit an existing entry\n"
    printf "use 'todo' to see your current list"
}
 
case $1 in
    add)
        add
        exit 0
        ;;
    del)
        del
        exit 0
        ;;
    edit)
        edit
        exit 0
        ;;
    init)
        init
        exit 0
        ;;
    help)
        help
        exit 0
        ;;
esac
 
show