import os
import shutil


def copy_evidence_debug():
    source_root = "/Users/aboudonji/Library/CloudStorage/GoogleDrive-aboudonji@gmail.com/My Drive/Universidad Anáhuac/Conference Presentations/Artificial Intelligence Foundations/Artificial Intelligence Foundations Conferences"
    dest_root = os.path.join(
        source_root, "Evolutionary Computation in Industrial Engineering", "Evidencias")

    target_folders = [
        "conf (1) IA",
        "conf (2) IA - Machine Learning",
        "conf (3) IA - Optimization",
        "IA Conf(7) - Evolutionary Computation_2"
    ]

    print(f"Source Root: {source_root}")
    print(f"Dest Root: {dest_root}")

    for item in os.listdir(source_root):
        if item not in target_folders:
            continue

        print(f"\nProcessing target folder: {item}")
        source_item_path = os.path.join(source_root, item)
        dest_item_path = os.path.join(dest_root, item)

        if not os.path.exists(dest_item_path):
            os.makedirs(dest_item_path)
            print(f"  Created destination: {dest_item_path}")

        files_in_source = os.listdir(source_item_path)
        print(f"  Files found in source: {files_in_source}")

        files_copied = 0
        for file in files_in_source:
            if file.lower().endswith(".pdf"):
                src_file = os.path.join(source_item_path, file)
                dst_file = os.path.join(dest_item_path, file)
                try:
                    shutil.copy2(src_file, dst_file)
                    print(f"  SUCCESS: Copied {file}")
                    files_copied += 1
                except Exception as e:
                    print(f"  ERROR: Failed to copy {file}. Reason: {e}")
            else:
                # print(f"  Skipped {file} (not PDF)")
                pass

        print(f"  Total copied: {files_copied}")


if __name__ == "__main__":
    copy_evidence_debug()
