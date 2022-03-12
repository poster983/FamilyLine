

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

void popAllPages(BuildContext context) {
  while(true) {
    try {
      context.pop();
    } catch(e) {
      break;
    }
    
  }
}