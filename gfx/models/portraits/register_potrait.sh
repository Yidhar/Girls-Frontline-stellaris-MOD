
function gen_potrait_list() {
	# ${1} - first param in main
	# ${2} - count of tabs
	# #{3} - max count of portraits
	file="${1}.txt"
	tabcnt=${2}
	cnt=${3}
	tab=""
	for ((i = 0; i < tabcnt - 1; i++)); do
		tab=${tab}"\t"
	done
	echo -e "${tab}portraits = {" >> "${file}"
	for ((i = 0; i < cnt; i++)); do
		printf "${tab}\t${1}_%03d\n" ${i} >> "${file}"
	done
	echo -e "${tab}}" >> "${file}"
}

if [ ${1} ]
then
	txt="${1}.txt"
	touch "${txt}"
	# read and register potrait
	echo -e "portraits = {" > "${txt}"
	cd "${1}"
	cnt=0
	for file in *; do
		if [ "${file##*.}"x == "dds"x ]; then
			printf "\t${1}_%03d = { texturefile = \"gfx/models/portraits/${1}/${file}\" }\n" ${cnt} >> "../${txt}"
			((cnt++))
		fi
	done
	cd "../"
	echo -e "}\n" >> "${txt}"

	# register potrait_group
	echo -e "portrait_groups = {\n\t${1} = {\n\t\tdefault = ${1}_000" >> "${txt}"
	
	# game setup
	echo -e "\t\tgame_setup = {" >> "${txt}"
	echo -e "\t\t\tadd = {" >> "${txt}"
	gen_potrait_list "${1}" 5 ${cnt}
	echo -e "\t\t\t}" >> "${txt}"
	echo -e "\t\t}" >> "${txt}"

	# species
	echo -e "\t\tspecies = {" >> "${txt}"
	echo -e "\t\t\tadd = {" >> "${txt}"
	gen_potrait_list "${1}" 5 ${cnt}
	echo -e "\t\t\t}" >> "${txt}"
	echo -e "\t\t}" >> "${txt}"

	# pop
	echo -e "\t\tpop = {" >> "${txt}"
	echo -e "\t\t\tadd = {" >> "${txt}"
	gen_potrait_list "${1}" 5 ${cnt}
	echo -e "\t\t\t}" >> "${txt}"
	echo -e "\t\t}" >> "${txt}"

	# leader
	echo -e "\t\tleader = {" >> "${txt}"
	leader_class=("scientist" "general" "admiral" "governor" "ruler")
	for class in ${leader_class[@]}; do
		echo -e "\t\t\tadd = {" >> "${txt}" >> "${txt}"
		echo -e "\t\t\t\ttrigger = { leader_class = ${class} }" >> "${txt}"
		gen_potrait_list "${1}" 5 ${cnt}
		echo -e "\t\t\t}" >> "${txt}"
	done
	echo -e "\t\t}" >> "${txt}"

	# ruler
	echo -e "\t\truler = {" >> "${txt}"
	echo -e "\t\t\tadd = {" >> "${txt}"
	gen_potrait_list "${1}" 5 ${cnt}
	echo -e "\t\t\t}" >> "${txt}"
	echo -e "\t\t}" >> "${txt}"

	echo -e "\t}\n}" >> "${txt}"
	mv "${txt}" "../../portraits/portraits/${txt}"
else
	echo "Usage:"
	echo -e "  register_potrait.sh [folder name]"
	echo -e "  * Put this script under gfx/models/portraits/"
	echo -e "  * Script will generate a [folder name].txt containing portraits info and move it to gfx/portraits/portraits/"
	echo "Example:"
	echo -e "  register_potrait.sh GF_nc"
fi