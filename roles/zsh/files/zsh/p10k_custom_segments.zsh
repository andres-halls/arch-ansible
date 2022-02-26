function prompt_nice_exit_code() {
  integer status_code="$_p9k__status"

  if (( status_code == 0 )); then
    p10k segment -s OK -i '✔' -f 70
  else
    $(exit $status_code)
    p10k segment -s ERROR -i '✘' -f 160 -t "$(nice_exit_code)"
  fi
}
