# --- proxy (v2raya, HTTP 20171; fallback 20172) ---
export http_proxy="http://127.0.0.1:20171"
export https_proxy="$http_proxy"
export all_proxy="$http_proxy"
export no_proxy="localhost,127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
export HTTP_PROXY="$http_proxy"
export HTTPS_PROXY="$http_proxy"
export ALL_PROXY="$all_proxy"
export NO_PROXY="$no_proxy"
