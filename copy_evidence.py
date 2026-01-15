import os
import shutil

def copy_evidence():
    source_root = "/Users/aboudonji/Library/CloudStorage/GoogleDrive-aboudonji@gmail.com/My Drive/Universidad Anáhuac/Conference Presentations/Artificial Intelligence Foundations/Artificial Intelligence Foundations Conferences"
    
    # The destination is inside one of the folders in the source root, so we need to be careful.
    dest_root = os.path.join(source_root, "Evolutionary Computation in Industrial Engineering", "Evidencias")
    
    # Create the destination directory if it doesn't exist
    if not os.path.exists(dest_root):
        os.makedirs(dest_root)
        print(f"Created directory: {dest_root}")
    else:
        print(f"Directory already exists: {dest_root}")

    # Iterate over items in the source root
    for item in os.listdir(source_root):
        source_item_path = os.path.join(source_root, item)
        
        # Skip if it's not a directory
        if not os.path.isdir(source_item_path):
            continue
            
        # Skip the folder that contains the destination to avoid recursion/loops
        # The user wants to copy folders *like* "conf (1) IA", etc.
        # The destination is inside "Evolutionary Computation in Industrial Engineering".
        # We should probably skip "Evolutionary Computation in Industrial Engineering" itself 
        # because the user said "create folders with the same names as the original folders... e.g. conf(1) IA".
        # It implies they want the *other* conference folders copied *into* this one specific folder's "Evidencias" subfolder.
        if item == "Evolutionary Computation in Industrial Engineering":
            continue
            
        # Define the new destination folder for this item
        dest_item_path = os.path.join(dest_root, item)
        
        # Create the subfolder in Evidencias
        if not os.path.exists(dest_item_path):
            os.makedirs(dest_item_path)
            print(f"Created subfolder: {dest_item_path}")
            
        # Walk through the source subfolder to find PDFs
        # The user said "content of these new folders should only have the PDF files".
        # It's possible the source folders have sub-subfolders. 
        # For simplicity and based on "content... only have PDF files", I will look for PDFs in the top level of that folder.
        # If deep recursion is needed, I'd need to know. Assuming flat structure within the conference folders for now 
        # or flattening it. "only have the PDF files" usually implies a simple collection.
        # Let's check if there are PDFs in the root of these folders.
        
        files_copied = 0
        for file in os.listdir(source_item_path):
            if file.lower().endswith(".pdf"):
                src_file = os.path.join(source_item_path, file)
                dst_file = os.path.join(dest_item_path, file)
                shutil.copy2(src_file, dst_file)
                files_copied += 1
                
        print(f"Copied {files_copied} PDFs from '{item}' to 'Evidencias/{item}'")

if __name__ == "__main__":
    copy_evidence()
