#include <iostream>

int minimum(int t1, int t2, int t3, int t4);

int main(){

	std::cout << minimum(15,6,17,8) << std::endl;
	std::cout << minimum(4,3,2,1) << std::endl;

	return 0;
}
int minimum(int t1, int t2, int t3, int t4){
	int minT;
	minT = t1;
	if (t2<minT){
		minT=t2;
	}
	if (t3<minT){
		minT=t3;
	}
	if (t3<minT){
		minT=t3;
	}
	if (t4<minT){
		minT=t4;
	}
	return minT;
}
