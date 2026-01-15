import os


def check_folders():
    source_root = "/Users/aboudonji/Library/CloudStorage/GoogleDrive-aboudonji@gmail.com/My Drive/Universidad Anáhuac/Conference Presentations/Artificial Intelligence Foundations/Artificial Intelligence Foundations Conferences"

    folders_to_check = [
        "conf (1) IA",
        "conf (2) IA - Machine Learning",
        "conf (3) IA - Optimization",
        "IA Conf(7) - Evolutionary Computation_2"
    ]

    print(f"Checking source root: {source_root}")

    if not os.path.exists(source_root):
        print("Source root does not exist!")
        return

    all_items = os.listdir(source_root)
    print(f"Found {len(all_items)} items in source root.")

    for folder_name in folders_to_check:
        print(f"\n--- Checking '{folder_name}' ---")
        if folder_name not in all_items:
            print(
                f"WARNING: Folder '{folder_name}' NOT found in source root listdir.")
            # Try to find a partial match
            for item in all_items:
                if folder_name in item or item in folder_name:
                    print(f"  Did you mean: '{item}'?")
            continue

        folder_path = os.path.join(source_root, folder_name)
        if not os.path.isdir(folder_path):
            print(f"'{folder_name}' is not a directory.")
            continue

        files = os.listdir(folder_path)
        print(f"Contents of '{folder_name}': {files}")

        pdfs = [f for f in files if f.lower().endswith(".pdf")]
        print(f"PDFs found: {pdfs}")


if __name__ == "__main__":
    check_folders()
