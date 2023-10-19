import csv
import sys

def parse_csv_to_execute(fname:str, execute_name:str, replace_null: bool = False) -> None:
    """ Script semi-fonctionnel : comme les données ne sont pas 100% parfaites 
    (guillemets, virgules et apostrophes seules), il est potentiellement important de 
    passer au travers à la main pour les problèmes possibles
    """


    open_file = open(fname, 'r')
    csv_file = csv.reader(open_file, delimiter=',')
    next(csv_file)

    result = ""
    for row in csv_file:          
        ligne_courante = ""
        for value in row:
            value = value.strip()    
            value = "'" + value + "'," 
            ligne_courante += value
        
        ligne_courante = ligne_courante.rstrip(',')
        ligne_courante = ligne_courante.replace('"', '')
        
        # à discuter avec JC
        if (replace_null):
            ligne_courante = ligne_courante.replace("'-'", "NULL")
        
        result += f"EXECUTE {execute_name}({ligne_courante});\n"
        
    open_file.close()

    return result

def write_to_file(content:str, fname:str):
    f = open(fname, "w")
    f.write(content)
    f.close()
    




if __name__ == "__main__":
    output = parse_csv_to_execute("technical_specifications.csv", "ins_technical_spec", replace_null=True)
    write_to_file(output, "technical_specification_FINAL.txt")