import os, tarfile, argparse, struct, re
from datetime import datetime


def args_parse():
    """
    Command Argument Parse.
    """

    parser = argparse.ArgumentParser(
        prog='argparseTest',
        usage='Demonstration of argparser',
        description='description',
        epilog='end',
        add_help=True
    )

    parser.add_argument('-s', '--src', required=True, help='Backup source directory.')
    parser.add_argument('-d', '--dst', required=True, help='Backup destination directory.')
    parser.add_argument('-e', '--exclude', required=False, help='Exclude regexp pattern.', action='append')
    parser.add_argument('-v', '--verbose')

    return parser.parse_args()

exclude_list = None


def is_exclude(file_path):
    for exclude_pattern in exclude_list:
        if exclude_pattern.match(file_path):
            print(f"Exclude: {file_path}")
            return True
    return False


if __name__ == '__main__':
    """
    Main.
    """

    args = args_parse()

    src = args.src
    dst = args.dst

    if args.exclude:
        exclude_list = [re.compile(exclude) for exclude in args.exclude] 
    
    exec_datetime = datetime.now()
    exec_datetime_str = exec_datetime.strftime('%Y-%m-%d_%H.%M.%S')
    tar = tarfile.open(os.path.join(dst, f'{exec_datetime_str}.tar.gz'), 'w:gz', compresslevel = 9)

    for _root, _dirs, _files in os.walk(src):
        print("@@@ ------------" + _root)
        fd_cnt = len(_files) + len(_dirs)
        print(fd_cnt)

        for _file in _files:
            file_path = os.path.join(_root, _file)
            print(file_path)

            if is_exclude(file_path):
                fd_cnt = fd_cnt - 1
                continue

            tar.add(file_path)
            is_empty_dir = False

        if fd_cnt == 0:
            print("EMPTY :" + _root)
            tar.add(_root)

    tar.close()
