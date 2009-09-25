
# stringent.sh copyright michael potter 2008

# stringent.sh is intended to reduce the problems associated with
# using bash by turning on bash options that make errors more
# apparent.  This will not eliminate problems and I am sure there
# is some case where some problem will be made worse.
# USE AT YOUR OWN RISK.

set -o errexit	# errexit first
set -o noclobber
set -o nounset
set -o pipefail    # if you fail on this line, get a newer version of bash.

function traperr
{
   declare -i i;
   declare -i nestlevel;
   declare Message=${1:-""}

   nestlevel=${#FUNCNAME[@]}

   if (( $nestlevel <= 2 ))
   then
      echo "ERROR: ${BASH_SOURCE[1]}:${BASH_LINENO[0]} $Message" >&2
   else
      echo "ERROR: ${FUNCNAME[1]}(${BASH_SOURCE[1]}:~${BASH_LINENO[0]}) $Message" >&2
      for (( i = 2 ; i < $nestlevel ; i++ ))
      do
         echo "      ${FUNCNAME[$i]}(${BASH_SOURCE[$i]}:~${BASH_LINENO[($i-1)]})" >&2
      done
   fi
   # if BASH_SUBSHELL is 0, then script will exit anyway.
   if (( $BASH_SUBSHELL >= 1 ))
   then
      kill $$
   fi
}

function traperrsimple
{
   # Use this function if the above function fails
   echo "ERROR: ${BASH_SOURCE[0]} ${LINENO}" >&2
   # if BASH_SUBSHELL is 0, then script will exit anyway.
   if (( $BASH_SUBSHELL >= 1 ))
   then
      kill $$
   fi
}

set -o errtrace
trap traperr ERR

function errexiton
{
   set -o errexit
   trap traperr ERR
}

function errexitoff
{
   set +o errexit
   trap '' ERR
}

