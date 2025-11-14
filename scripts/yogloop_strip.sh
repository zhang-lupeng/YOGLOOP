#yogloop_strip.sh - Script for generating APA (aggrate plot analysis)
# Required parameters:
#   -l: Mini-loop file (anchor regions)
#   -f: Original interaction file in BEDPE format
#   -o: output dir
# Optional parameters:
#   -t: Number of thread
#   -s: Heatmap minimum value (default: 0)
#   -m: Heatmap maximum value (default: 1)

# Initialize default values
MIN_VAL=""
MAX_VAL=""
MINI_FILE=""
BEDPE_FILE=""

# Parse command line arguments
while getopts "l:f:t:s:m:" opt; do
    case $opt in
        l) MINI_FILE="$OPTARG" ;;
        f) BEDPE_FILE="$OPTARG" ;;
        t) THREAD="$OPTARG" ;;
        s) MIN_VAL="$OPTARG" ;;
        m) MAX_VAL="$OPTARG" ;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
        :) echo "Option -$OPTARG requires an argument" >&2; exit 1 ;;
    esac
done

# Check if required parameters are provided
if [ -z "$MINI_FILE" ]; then
    echo "Error: -l (miniloop file bed format), -f (interaction file bedpe format)"
    echo "Usage: $0 -l <miniloop_file> -f <bedpe_file> -t <threads> [-s min_value] [-m max_value]"
    exit 1
fi

# Check if input files exist
if [ ! -f "$MINI_FILE" ]; then
    echo "Error: MiniLoop file $MINI_FILE does not exist"
    exit 1
fi

if [ ! -d "$BEDPE_FILE" ]; then
    echo "Error: BEDPE dir $BEDPE_FILE does not exist"
    exit 1
fi
mkdir tmp
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
awk -v bedpe=$BEDPE_FILE '{print $1,$2,$3,$4,bedpe}' $MINI_FILE | xargs -n 1 -I {} -P $THREAD sh -c "sh $SCRIPT_DIR/strip_plot.sh {}"
cat tmp/* | awk '{print $3}' | awk '{row = (NR-1) % 40000 + 1;for(i=1; i<=NF; i++){sum[row] += $i}}END{for(i=1; i<=40000; i++){print sum[i]}}' | xargs -n 200 > miniloop_square.txt
Rscript $SCRIPT_DIR/strip_plot_heatmap.r miniloop_square.txt $MIN_VAL $MAX_VAL

