#include <iostream>

int searchArray(int array[], int size, int element);

int main(){

	int num[] = {1,2,3,4,5,6,7,8,9,10};
	int size = sizeof(num)/sizeof(int);

	int num2;
	int index;

	std::cout << "Enter the number to find >> ";
	std::cin >> num2;

	index = searchArray(num, size, num2);

	if ( index == -1 ){
		std::cout << "Not Found!" << std::endl;
	}
	else{
		std::cout << index << std::endl;
	}


	return 0;
}

int searchArray(int array[], int size, int element){
	for ( int i=0; i <= size; i++ ){
		if (element == array[i]){
			return i;
		}
	}
	return -1;
}
