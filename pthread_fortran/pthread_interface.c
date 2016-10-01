#include <pthread.h>

void pthread_create_(pthread_t* thread, const pthread_attr_t* attr, void *(*func)(void *), void* arg)
{
	pthread_create(thread, attr, func, arg);
}

void pthread_join_(pthread_t* t)
{
	pthread_join(*t, NULL);
}

void pthread_attr_init_(pthread_attr_t* attr)
{
	pthread_attr_init(attr);
}

void pthread_attr_destroy_(pthread_attr_t* attr)
{
	pthread_attr_destroy(attr);
}
